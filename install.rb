# frozen_string_literal: true

# Install script for setting up Ruby and Python with rbenv and pyenv
class InstallScript
  def install
    install_homebrew

    install_rbenv

    install_ruby_build

    update_zshrc_for_rbenv

    setup_ruby('2.7.3')

    install_pyenv

    update_zshrc_for_pyenv

    update_zprofile_for_pyenv

    setup_python('3.10.1')

    # puts oh_my_zsh_installed?
  end

  def setup_ruby(version = '2.7.3')
    install_ruby(version)
    update_global_ruby(version)
  end

  def setup_python(version = '3.10.1')
    install_python(version)
    update_global_python(version)
  end

  def update_global_python(version = '3.10.1')
    puts "🚀 setting global python version to #{version}..."
    system "pyenv global #{version}" unless python_shim?
    puts "global Python version used is rvbenv managed. ✅\n " if python_shim?
  end

  def install_python(version = '3.10.1')
    puts "🚀 installing python #{version}"
    system "pyenv install #{version}" unless correct_python_version?
    puts "python version 3.10.1 already installed ✅\n " if correct_python_version?
  end

  def update_zprofile_for_pyenv
    puts '🚀 Updating .zprofile file with pyenv...'
    zprofile_path = File.expand_path('~/.zprofile')
    unless zprofile_contains_pyenv?(zprofile_path)
      File.open(zprofile_path, 'a') do |f|
        f.puts 'eval "$(pyenv init --path)"'
        puts "zprofile upated for pyenv ✅\n "
      end
    end
    puts "zprofile already contains eval for pyenv ✅\n " if zprofile_contains_pyenv?(zprofile_path)
    system 'source ~/.zprofile' unless zprofile_contains_pyenv?(zprofile_path)
  end

  def update_zshrc_for_pyenv
    puts '🚀 Updating .zshrc file with pyenv...'
    zshrc_path = File.expand_path('~/.zshrc')
    unless zshrc_contains_pyenv?(zshrc_path)
      File.open(zshrc_path, 'a') do |f|
        f.puts 'eval "$(pyenv init -)"'
        puts "zshrc upated for pyenv ✅\n "
      end
    end
    puts "zshrc already contains eval for pyenv ✅\n " if zshrc_contains_pyenv?(zshrc_path)
    system 'source ~/.zshrc' unless zshrc_contains_pyenv?(zshrc_path)
  end

  def install_pyenv
    puts '🚀 installing pyenv...'
    if pyenv_installed?
      puts "pyenv already installed... skipping ✅ \n "
    else
      system 'brew install pyenv'
      puts "pyenv installed ✅\n " if pyenv_installed?
    end
  end

  def update_global_ruby(version = '2.7.3')
    puts "🚀 setting global ruby version to #{version}..."
    system "rbenv global #{version}" unless ruby_shim?
    puts "global Ruby version used is rbenv managed. ✅\n " if ruby_shim?
  end

  def install_ruby(version = '2.7.3')
    puts "🚀 installing ruby version to #{version}..."
    system "rbenv install #{version}" unless correct_ruby_version?
    puts "ruby version #{version} already installed ✅\n " if correct_ruby_version?
  end

  def update_zshrc_for_rbenv
    puts '🚀 Updating .zshrc file with rbenv...'
    zshrc_path = File.expand_path('~/.zshrc')
    unless zshrc_contains_rbenv?(zshrc_path)
      File.open(zshrc_path, 'a') do |f|
        f.puts 'eval "$(rbenv init -)"'
        puts "zshrc upated for rbenv ✅\n "
      end
    end
    puts "zshrc already contains eval for rbenv ✅\n " if zshrc_contains_rbenv?(zshrc_path)
    system 'source ~/.zshrc' unless zshrc_contains_rbenv?(zshrc_path)
  end

  def install_ruby_build
    puts '🚀 installing ruby-build...'
    if ruby_build_installed?
      puts "ruby build already installed... skipping ✅ \n "
    else
      system 'brew install ruby-build'
      puts "ruby-build installed ✅\n " if ruby_build_installed?
    end
  end

  def install_rbenv
    puts '🚀 installing rbenv...'
    if rbenv_installed?
      puts "rbenv already installed... skipping ✅\n "
    else
      system 'brew install rbenv'
      puts "rbenv installed ✅\n " if rbenv_installed?
    end
  end

  def install_homebrew
    puts '🚀 installing Homebrew...'
    unless homebrew_installed?
      system '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
    end
    puts "Homebrew already installed ✅ \n " if homebrew_installed?
  end

  def zprofile_contains_pyenv?(path)
    val = false
    File.open(path) do |file|
      file.find do |line|
        return val = true if line.strip == 'eval "$(pyenv init --path)"'
      end
    end
    val
  end

  def zshrc_contains_pyenv?(path)
    val = false
    File.open(path) do |file|
      file.find do |line|
        return val = true if line.strip == 'eval "$(pyenv init -)"'
      end
    end
    val
  end

  def zshrc_contains_rbenv?(path)
    val = false
    File.open(path) do |file|
      file.find do |line|
        return val = true if line.strip == 'eval "$(rbenv init -)"'
      end
    end
    val
  end

  def correct_python_version?
    val = `python --version`
    val.strip.include? '3.10.1'
  end

  def correct_ruby_version?
    val = `ruby --version`
    val.strip.include? '2.7.3'
  end

  def python_shim?
    val = `which python`
    val.strip.include? '.pyenv'
  end

  def ruby_shim?
    val = `which ruby`
    val.strip.include? '.rbenv'
  end

  def oh_my_zsh_installed?
    # Dir.exist?('~/.oh-my-zsh')
    File.directory? File.expand_path('~/.oh-my-zsh')
  end

  def homebrew_installed?
    'which homebrew'.strip.empty? == false
  end

  def rbenv_installed?
    'which rbenv'.strip.empty? == false
  end

  def ruby_build_installed?
    'which ruby-build'.strip.empty? == false
  end

  def pyenv_installed?
    'which pyenv'.strip.empty? == false
  end
end

InstallScript.new.install
