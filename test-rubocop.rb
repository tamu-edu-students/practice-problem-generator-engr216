def badMethodName # Offense 1: Method name should be snake_case
    puts "Hello World"  # Offense 2: Indentation
      puts "This line has extra spaces at the beginning"  # Offense 3: Extra spaces
      if true
          puts "Improper indentation inside if"  # Offense 4: Indentation issue
      end
    end
    