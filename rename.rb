#! /usr/bin/env ruby

def installing_missing_gems(&block)
  yield
rescue LoadError => e
  gem_name = e.message.split('--').last.strip
  install_command = 'gem install ' + gem_name
  
  # install missing gem
  puts 'Для продолжения необходимы следующие компоненты: ' + gem_name
  print 'Установить автоматически? [yN] '
  gets.strip =~ /y/i or exit(1)
  system(install_command) or exit(1)
  
  # retry
  Gem.clear_paths
  puts 'Пробуем снова ...'
  require gem_name
  retry
end

def sync(old_name, proj_name)
    if old_name == proj_name
      puts "\nОшибка! Вы ввели одинаковые имена.".red
      exit()
    end
    if old_name.length <= 2 || proj_name.length <= 2
      puts "\nОшибка! Название не может быть меньше 3 символов.".red
      exit()
    end

    #make first letter uppercase
    proj_name = proj_name.slice(0,1).capitalize + proj_name.slice(1..-1)

    #Rename .xcodeproj
    if File.exists?("#{old_name}.xcodeproj")
      puts "#{"#{old_name}.xcodeproj"} был переименован".yellow
      File.rename("#{old_name}.xcodeproj", "#{proj_name}.xcodeproj")
    end
    #Delete .xcworkspace
    Dir.glob("./**/*.xcworkspace").reverse.each do |f|
      puts "#{f} был удален".red
      FileUtils.rm_rf(Dir.glob(f))
    end

    #Update content of xcodeproj file (pbxproj)
    Dir.glob("./**/*.pbxproj").each do |f|
      findAndReplaceContentOfFile(f, old_name, proj_name)
    end

    #Update content of Pod file
    Dir.glob("Podfile").each do |f|
      findAndReplaceContentOfFile(f, old_name, proj_name)
    end

    #Update files and folders names
    Dir.glob("./**/"+old_name+"*").reverse.each do |f|
      puts "Изменил имя: #{f}".green
      newName = File.basename(f).sub(old_name, proj_name)
      File.rename(f, "#{File.dirname(f)}/#{newName}")
    end

    #Update content of xcscheme file
    Dir.glob("./**/*.xcscheme").each do |f|
      findAndReplaceContentOfFile(f, old_name, proj_name)
    end

    #Update content of Tests files
    Dir.glob("./**/"+proj_name+"*Tests.*").each do |f|
      findAndReplaceContentOfFile(f, old_name, proj_name)
    end

    #Clear userdata
    Dir.glob("./**/xcuserdata").reverse.each do |f|
      FileUtils.rm_rf(Dir.glob(f))
      puts "#{f} был удален".red
    end

    #Pod install
    if File.exists?("Podfile")
      puts "\nОбнаружен Podfile... Инициирую установку...\n".green
      system("pod install")
    end

    puts "\nГотово! Синхронизация имени проекта завершена.".green
    puts "\nЕсли вы используете 'CoreData' измените вашу конфигурацию для 'URLForResource', т.к. имя '.xcdatamodeld' было изменено.".yellow
    puts "\nВ проекте будет множество warning'ов из-за остутствия файлов - все пройдет после первого commit'а, который лучше сделать через терминал :)".yellow

    renameMainDirectory()
end

def renameMainDirectory()
  oldFolderName = File.basename(Dir.getwd)
  newFolderName = ask "\nВведите 'q' или нажмите 'enter' для завершения. Если же вы хотите переименовать корневую папку проекта " + "#{oldFolderName}".magenta + " то введите новое название." 
  if newFolderName.strip == "" || newFolderName.strip == "q"
     exit()
  else
    accept = ask "\nЗаменить " + "#{oldFolderName}".magenta + " на " + "#{newFolderName.strip}".blue + "? Нажмите 'enter' для подтверждения. Введите 'q' чтобы выйти."
    if accept.strip == ""
      rename_main_directory = "mv ../#{oldFolderName} ../#{newFolderName}"
      system(rename_main_directory)
    else
      exit()
    end
  end
end

def findAndReplaceContentOfFile(f, old_name, proj_name)
  filePath = File.absolute_path(f)
  if File.file?(filePath) 
    puts "#{filePath} содержание файла было изменено".yellow
    search_and_replace_file = "sed 's/#{old_name}/#{proj_name}/g' #{filePath} > #{filePath}2"
    system(search_and_replace_file)
    File.delete("#{filePath}")
    File.rename("#{filePath}2", "#{filePath}")
  end
end

def soundoff(xcodeproj_file_arr)
  if xcodeproj_file_arr.count > 1
    puts "ERROR: there's more than one .xcodeproj file."
    exit()
  elsif xcodeproj_file_arr.count == 0
    puts "ERROR: cannot find xcodeproj file"
    exit()
  end
end

def start()
  xcodeproj_file_arr = Dir.glob('*.xcodeproj')

  tests_dir_array = Dir.glob('*Tests')
  full_name_of_test = tests_dir_array[0]
  name_of_test = full_name_of_test[0,full_name_of_test.length-5]

  name_of_directory = File.basename(Dir.getwd)
  proj_name = xcodeproj_file_arr[0].split(".")[0]

  #check for errors
  soundoff(xcodeproj_file_arr)

  puts "WARNING: Прежде чем продолжить закройте Xcode.".red
  puts "WARNING: Данный скрипт может повредить проект! Сделайте резервную копию.".red
  puts "WARNING: Желательно чтобы имена классов не содержали имя проекта.".red

  new_name = ask "\nВведите '1' или нажмите 'enter' чтобы переименовать текущее название " + "#{proj_name}".magenta + "\nВведите '2' чтобы заменить " + "#{name_of_test}".magenta + " на " +"#{proj_name}".blue + "\nВведите '3' чтобы заменить " + "#{name_of_directory}".magenta + " на " +"#{proj_name}".blue + " \nЕсли все эти варианты не подходят - введите " + "название".magenta + ", которое нужно заменить.\nВведите 'q' чтобы выйти."

  if new_name.strip == "q"
    exit()
  elsif new_name.strip == "1" || new_name.strip == ""
    data = ask "Введите " + "новое название".blue + " проекта. Введите 'q' чтобы выйти."
    if data.strip == "" || data.strip == "q"
      exit()
    else
      data2 = ask "\nЗаменить " + "#{proj_name}".magenta + " на " + "#{data.strip}".blue + "? Нажмите 'enter' для подтверждения. Введите 'q' чтобы выйти."
      if data2.strip == ""
        sync(proj_name, data.strip)
      else
        exit()
      end
    end
  elsif new_name.strip == "2"
    sync(name_of_test, proj_name)
  elsif new_name.strip == "3"
    sync(name_of_directory, proj_name)
  else
    data = ask "\nЗаменить " + "#{new_name.strip}".magenta + " на " + "#{proj_name}".blue + " ? Нажмите 'enter' для подтверждения \nЕсли " + "новое название".blue + " не подходит - введите свой вариант" + "\nВведите 'q' чтобы выйти."
    if data.strip == ""
      sync(new_name.strip, proj_name)
    elsif data.strip == "q"
      exit()
    else
      data2 = ask "\nЗаменить " + "#{new_name.strip}".magenta + " на " + "#{data.strip}".blue + "? Нажмите 'enter' для подтверждения. Введите 'q' чтобы выйти."
      if data2.strip == ""
        sync(new_name.strip, data.strip)
      else
        exit()
      end
    end
  end
end

installing_missing_gems do
  require "fileutils"
  require "highline/import"
  require "colorize"
  start()
end
