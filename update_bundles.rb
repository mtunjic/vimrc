#!/usr/bin/env ruby

# Changelog:
# - added zip support
# - added support for cmd-line list of bundles to update

git_bundles = [ 
  "git://github.com/astashov/vim-ruby-debugger.git",
  "git://github.com/vim-scripts/tlib.git",
  "git://github.com/msanders/snipmate.vim.git",
  "git://github.com/scrooloose/nerdtree.git",
  "git://github.com/timcharper/textile.vim.git",
  "git://github.com/tpope/vim-cucumber.git",
  "git://github.com/tpope/vim-fugitive.git",
  "git://github.com/tpope/vim-git.git",
  "git://github.com/tpope/vim-haml.git",
  "git://github.com/tpope/vim-markdown.git",
  "git://github.com/tpope/vim-rails.git",
  "git://github.com/tpope/vim-repeat.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tpope/vim-vividchalk.git",
  "git://github.com/tsaleh/vim-align.git",
  "git://github.com/tsaleh/vim-shoulda.git",
  "git://github.com/tsaleh/vim-supertab.git",
  "git://github.com/tsaleh/vim-tcomment.git",
  "git://github.com/vim-ruby/vim-ruby.git",
  #"git://github.com/vim-bundles/fuzzyfinder.git",
  "git://github.com/slack/vim-fuzzyfinder.git",
  #"git://github.com/clones/vim-fuzzyfinder.git",
  "git://github.com/jamis/fuzzyfinder_textmate.git",
  "git://github.com/borgand/ir_black.git",
  "git://github.com/mattn/gist-vim.git",
  "git://github.com/Shougo/neocomplcache/tree/master",
  "git://github.com/sjl/gundo.vim.git",
  "git://github.com/kchmck/vim-coffee-script.git",
  "git://github.com/vim-scripts/tcommand.git",
  "git://github.com/taq/vim-rspec.git",
  "git://github.com/scrooloose/syntastic.git",
  "git://github.com/mirell/vim-matchit.git",
  "git://github.com/ciaranm/inkpot.git",
  "git://github.com/charlietanksley/Rainbow-Parenthsis-Bundle.git",
  "git://github.com/vim-scripts/ri-viewer.git",
  "git://github.com/vim-scripts/rubycomplete.vim.git",
  "git://github.com/rstacruz/sparkup.git",
  "git://github.com/vim-scripts/YankRing.vim.git",
  "git://github.com/jpalardy/vim-slime.git",
  "git://github.com/vim-scripts/scratch.vim.git"
  
]

vim_org_scripts = [
  ["IndexedSearch", "7062",  "plugin"],
  ["jquery",        "12107", "syntax"],
  #["bufexplorer",   "12904", "zip"],
  ["minibufexpl",   "3640",   "plugin"],
  ["taglist",       "7701",  "zip"],
  ["vcscommand",    "12743", "zip"],
  ["l9", "13948", "zip"]
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")
FileUtils.rm_rf "bundle" if File.directory?("bundle")
Dir.mkdir "bundle"

FileUtils.cd(bundles_dir)

# If ARGV is not empty, work only on listed bundles
def should_update(b)
  return ARGV.empty? || (ARGV.include?(b))
end


puts "Trashing #{ARGV.empty? ? 'everything' : ARGV.join(',')} (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d if should_update d}

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  next unless should_update dir
  puts "  Unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |name, script_id, script_type|
  next unless should_update name
  puts "  Downloading #{name}"
  local_file = File.join(name, script_type, "#{name}.#{script_type == 'zip' ? 'zip' : 'vim'}")
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
  end
  if script_type == 'zip'
    %x(unzip -d #{name} #{local_file})
  end
end


