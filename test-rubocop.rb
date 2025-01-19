def badMethodName # Offense 1: Method name should be snake_case
    puts "Hello World"  # Offense 2: Indentation
      puts "This line has extra spaces at the beginning"  # Offense 3: Extra spaces
      if true
          puts "Improper indentation inside if"  # Offense 4: Indentation issue
      end
    
      begin  # Offense 5: Useless `begin` block
        puts "This begin block is unnecessary"
      end
    
      long_line = "This is a very long line that goes beyond the RuboCop limit for line length, which should trigger an offense" # Offense 6: Line too long
    
      puts "single quotes should be used instead of double quotes" # Offense 7: Style violation
      arr = [ 1, 2,  3]  # Offense 8: Extra spaces inside array brackets
      h = { :key => "value" } # Offense 9: Hash rockets (`=>`) should be replaced with new syntax
      
      puts "Hello" if true  # Offense 10: Modifier `if` should be on a separate line
    end
    