class TeacherDashboardController < ApplicationController
  
  before_action :require_teacher
  before_action :load_semesters, only: %i[index manage_students student_history_dashboard]

  def require_teacher
    return if session[:user_type] == 'teacher' && current_teacher

    redirect_to login_path
    nil
  end

  def index
    @students = current_teacher.students
    apply_semester_filter
  end

  def manage_students
    @students = current_teacher.students
    apply_semester_filter
  end

  def student_history_dashboard
    # --- LOAD FILTER PARAMS ---
    @selected_semester_id = params[:semester_id] || "all"
    @selected_student_email = params[:student_email]
    @selected_category = params[:category] || "all"

  
    # --- STUDENT SCOPE ---
    @all_students = current_teacher.students
    @students = @all_students
    if @selected_semester_id.present? && @selected_semester_id != "all"
      @students = @students.by_semester(@selected_semester_id)
    end
    @students_for_dropdown = @students.to_a
    
      
    # --- SEARCH (optional, already implemented) ---
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @students = @students.where(
        'LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?',
        search_term, search_term, search_term
      )
    end
  
    # --- IF STUDENT FILTER APPLIED, NARROW SCOPE ---
    if @selected_student_email.present? && @selected_student_email != "all"
      @students = @students.where(email: @selected_student_email)
    
      student = @students.first
      @student_selected_semester_id = student&.semester_id

    
      if student.present?
        @total_unique_problems = Answer.select(:category, :template_id).distinct.count
    
        student_answers = Answer.where(student_email: student.email)
        @student_unique_attempts = student_answers.select(:category, :template_id).distinct.count
        @student_unique_correct = student_answers.where(correctness: true).select(:category, :template_id).distinct.count

        @student_total_attempted = student_answers.count
        @student_total_correct = student_answers.where(correctness: true).count
        @student_total_incorrect = @student_total_attempted - @student_total_correct
      
    
        @student_attempt_pie = {
          attempted: @student_unique_attempts,
          not_attempted: @total_unique_problems - @student_unique_attempts
        }
    
        @student_correct_pie = {
          correct: @student_unique_correct,
          incorrect: @total_unique_problems - @student_unique_correct}

          # 🔹 Build category-wise pie data for this student
        @student_category_pie_data = {}

        categories = [
          "Angular Momentum", "Confidence Intervals", "Engineering Ethics",
          "Experimental Statistics", "Finite Differences", "Harmonic Motion",
          "Measurement & Error", "Momentum & Collisions", "Particle Statics",
          "Propagation of Error", "Rigid Body Statics", "Universal Accounting Equation"
        ]

        categories.each do |cat|
          total_problems = Answer.where(category: cat).select(:template_id).distinct.count

          student_cat_answers = student_answers.where(category: cat)
          attempted = student_cat_answers.select(:template_id).distinct.count
          correct = student_cat_answers.where(correctness: true).select(:template_id).distinct.count

          @student_category_pie_data[cat] = {
            total: total_problems,
            attempted: attempted,
            not_attempted: total_problems - attempted,
            correct: correct,
            incorrect: total_problems - correct
          }
        end

      else
        flash.now[:alert] = "Student not found for the selected semester."
      end
    end

    
    
    
  
    # --- PREP STATS FOR LATER STEPS ---
    @all_answers = Answer.where(student_email: @students.pluck(:email))
    @category_stats = {} # (to be filled in next step)
    @holistic_participation = {} # (to be filled in next step)
    @holistic_correctness = 0 # (to be filled in next step)
    # --- BUILD HOLISTIC BUCKET STATS ---
    buckets = {
      "<25%" => 0,
      "25–50%" => 0,
      "50–75%" => 0,
      "75–99%" => 0,
      "100%" => 0
    }
    if @selected_student_email.present? && @selected_student_email != "all" &&
      @selected_category.present? && @selected_category != "all"
   
      @student = Student.find_by(email: @selected_student_email)
      @problem_history = Answer.where(student_email: @student.email, category: @selected_category)
    
      @template_ids = @problem_history.select(:template_id).distinct.pluck(:template_id).sort
    
      # Unique counts
      unique_total = Answer.where(category: @selected_category).select(:template_id).distinct.count
      unique_attempted = @problem_history.select(:template_id).distinct.count
      unique_correct = @problem_history.where(correctness: true).select(:template_id).distinct.count
    
      @unique_attempt_pie = {
        attempted: unique_attempted,
        not_attempted: unique_total - unique_attempted
      }
    
      @unique_correct_pie = {
        correct: unique_correct,
        incorrect: unique_total - unique_correct
      }
    
      # Total counts (based on actual answers)
      total_attempted = @problem_history.count
      total_correct = @problem_history.where(correctness: true).count
    
      @total_attempt_pie = {
        attempted: total_attempted,
        not_attempted: 0
      }
    
      @total_correct_pie = {
        correct: total_correct,
        incorrect: total_attempted - total_correct
      }
    end
   
   
    @student_emails = @students.pluck(:email)
    if @selected_student_email == "all" && @selected_category.present? && @selected_category != "all"
      # Holistic view scoped to selected category
      @category_total_unique_questions = Answer.where(category: @selected_category).select(:template_id).distinct.count
    
      buckets = { "<25%" => 0, "25–50%" => 0, "50–75%" => 0, "75–99%" => 0, "100%" => 0 }
      correct_buckets = buckets.dup
    
      @students.each do |student|
        answers = Answer.where(student_email: student.email, category: @selected_category)
    
        attempted = answers.select(:template_id).distinct.count
        correct = answers.where(correctness: true).select(:template_id).distinct.count
    
        attempt_ratio = attempted.to_f / @category_total_unique_questions
        correct_ratio = correct.to_f / @category_total_unique_questions
    
        def assign_bucket(r)
          case r
          when 1.0 then "100%"
          when 0.75..0.99 then "75–99%"
          when 0.5..0.75 then "50–75%"
          when 0.25..0.5 then "25–50%"
          else "<25%"
          end
        end
    
        buckets[assign_bucket(attempt_ratio)] += 1
        correct_buckets[assign_bucket(correct_ratio)] += 1
      end
    
      @category_attempted_buckets = buckets
      @category_correct_buckets = correct_buckets
    
      # Subsection: per-question breakdown (template_id-level)
      @category_question_data = {}

      Answer.where(category: @selected_category).select(:template_id).distinct.each do |row|
        template_id = row.template_id

        total_students = @students.count
        attempted_students = @students.count do |s|
          Answer.exists?(student_email: s.email, template_id: template_id, category: @selected_category)
        end

        correct_students = @students.count do |s|
          Answer.exists?(student_email: s.email, template_id: template_id, category: @selected_category, correctness: true)
        end

        @category_question_data[template_id] = {
          attempted: attempted_students,
          not_attempted: total_students - attempted_students,
          correct: correct_students,
          incorrect: total_students - correct_students
        }
      end
      @category_total_attempted = Answer.where(student_email: @student_emails, category: @selected_category).count
      @category_total_correct = Answer.where(student_email: @student_emails, category: @selected_category, correctness: true).count
      @category_total_incorrect = @category_total_attempted - @category_total_correct




    end
    

    correct_buckets = buckets.dup

    # Get the total number of unique problems (category + template_id combo)
    @total_unique_problems = Answer
      .select(:category, :template_id)
      .distinct
      .count

    @students.each do |student|
      student_answers = Answer.where(student_email: student.email)

      attempted = student_answers
        .select(:category, :template_id)
        .distinct
        .count

      correct = student_answers
        .where(correctness: true)
        .select(:category, :template_id)
        .distinct
        .count

      attempt_ratio = attempted.to_f / @total_unique_problems
      correct_ratio = correct.to_f / @total_unique_problems

      def assign_bucket(ratio)
        case ratio
        when 1.0
          "100%"
        when 0.75..0.99
          "75–99%"
        when 0.5..0.75
          "50–75%"
        when 0.25..0.5
          "25–50%"
        else
          "<25%"
        end
      end

      buckets[assign_bucket(attempt_ratio)] += 1
      correct_buckets[assign_bucket(correct_ratio)] += 1
    end

    @attempted_buckets = buckets
    @correct_buckets = correct_buckets

    categories = [
      "Angular Momentum", "Confidence Intervals", "Engineering Ethics",
      "Experimental Statistics", "Finite Differences", "Harmonic Motion",
      "Measurement & Error", "Momentum & Collisions", "Particle Statics",
      "Propagation of Error", "Rigid Body Statics", "Universal Accounting Equation"
    ]

    @category_bucket_data = {}

    categories.each do |cat|
      unique_problems = Answer.where(category: cat).select(:template_id).distinct.count

      buckets = { "<25%" => 0, "25–50%" => 0, "50–75%" => 0, "75–99%" => 0, "100%" => 0 }
      correct_buckets = buckets.dup

      @students.each do |student|
        student_answers = Answer.where(student_email: student.email, category: cat)

        attempted = student_answers.select(:template_id).distinct.count
        correct = student_answers.where(correctness: true).select(:template_id).distinct.count

        attempt_ratio = unique_problems.zero? ? 0 : attempted.to_f / unique_problems
        correct_ratio = unique_problems.zero? ? 0 : correct.to_f / unique_problems

        def assign_bucket(ratio)
          case ratio
          when 1.0 then "100%"
          when 0.75..0.99 then "75–99%"
          when 0.5..0.75 then "50–75%"
          when 0.25..0.5 then "25–50%"
          else "<25%"
          end
        end

        buckets[assign_bucket(attempt_ratio)] += 1
        correct_buckets[assign_bucket(correct_ratio)] += 1
      end

      @category_bucket_data[cat] = {
        total: unique_problems,
        attempted: buckets,
        correct: correct_buckets
      }
    end
    # Add this at the bottom of your student_history_dashboard method
    @total_attempted_all = @all_answers.count
    @total_correct_all = @all_answers.where(correctness: true).count
    @total_incorrect_all = @total_attempted_all - @total_correct_all



  end
  
  
  
 

  def student_history
    # Verify that we have a valid student email
    student_email = params[:student_email]
    log_student_history_request(student_email)

    return redirect_with_missing_email_alert if student_email.blank?
    return redirect_with_student_not_found_alert unless (@student = find_student_by_email(student_email))

    load_student_answers
    set_student_stats

    # Render the view template
    render 'teacher_dashboard/student_history'
  end

  def delete_semester_students
    semester_id = params[:semester_id]

    if semester_id.present?
      semester = Semester.find_by(id: semester_id)

      if semester
        students_count = current_teacher.students.by_semester(semester_id).count
        current_teacher.students.by_semester(semester_id).destroy_all

        redirect_to manage_students_path, notice: t('.success',
                                                    count: students_count,
                                                    semester: semester.name)
      else
        redirect_to manage_students_path, alert: t('.semester_not_found')
      end
    else
      redirect_to manage_students_path, alert: t('.no_semester_selected')
    end
  end

  private

  def redirect_with_missing_email_alert
    redirect_to teacher_dashboard_path, alert: t('teacher.student_email_required')
  end

  def redirect_with_student_not_found_alert
    redirect_to teacher_dashboard_path, alert: t('teacher.student_not_found')
  end

  def find_student_by_email(email)
    Student.find_by(email: email)
  end

  def log_student_history_request(student_email)
    Rails.logger.debug { "Student History: Looking for student with email #{student_email.inspect}" }
    Rails.logger.debug { "Params: #{params.inspect}" }
  end

  def load_student_answers
    @completed_questions = Answer.where(student_email: @student.email)
                                 .order(created_at: :desc)
  end

  def current_teacher
    @current_teacher ||= Teacher.find_by(id: session[:user_id])
  end

  def load_semesters
    @semesters = Semester.order(active: :desc, name: :asc)
    @current_semester_id = params[:semester_id]
  end

  def apply_semester_filter
    @students = @students.by_semester(@current_semester_id) if @current_semester_id.present?
  end

  def build_category_summaries(students)
    Answer.where(student_email: students.pluck(:email))
          .group(:category)
          .select('category,
                   COUNT(*) AS attempted,
                   SUM(CASE WHEN correctness THEN 1 ELSE 0 END) AS correct,
                   SUM(CASE WHEN correctness THEN 0 ELSE 1 END) AS incorrect')
          .to_h { |cat| format_category_summary(cat) }
  end

  def format_category_summary(cat)
    percentage = cat.attempted.zero? ? 0 : (cat.correct.to_f / cat.attempted * 100).round(1)
    [cat.category, { attempted: cat.attempted, correct: cat.correct, incorrect: cat.incorrect, percentage: percentage }]
  end

  def class_performance(students)
    answers = Answer.where(student_email: students.pluck(:email))
    @total_completed = {
      attempted: answers.count,
      correct: answers.where(correctness: true).count,
      incorrect: answers.where(correctness: false).count,
      percentage: answers.count.zero? ? 0 : (answers.where(correctness: true).count.to_f / answers.count * 100).round(1)
    }
  end

  def set_student_stats
    @attempted = @completed_questions.count
    @correct = @completed_questions.where(correctness: true).count
    @incorrect = @completed_questions.where(correctness: false).count
    @percentage_correct = @attempted.zero? ? 'N/A' : format('%.1f%%', (@correct.to_f / @attempted * 100))
  end
end
