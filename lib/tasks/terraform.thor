require "fileutils"
require "thor"
require "yaml"

class Terraform < Thor
  include Thor::Actions

  no_commands do
    def archive_release
      run "tar -cz --exclude=pkg --exclude=.git --exclude=lib -f #{@release_path} ."
    end

    def fetch_modules
      modules.each do |name, data|
        mdir = File.join(modules_path, name)
        if data.key? "git"
          get_module_git(data["git"], git_ref(data), mdir)
        elsif data.key? "file"
          untar_module(data["file"], mdir)
        elsif data.key? "s3"
          get_module_s3(data["s3"], mdir)
        end
      end
    end

    def get_module_git(uri, ref, dst)
      run "git clone -b #{ref} #{uri} #{dst}"
    end

    def get_module_s3(uri, dst)
      tmpdir = Dir.mktmpdir
      run "aws s3 cp #{uri} #{tmpdir}"
      untar_module(File.join(tmpdir, File.basename(uri)), dst)
    end

    def modules
      YAML.load_file modules_yml
    rescue
      {}
    end

    def modules_path
      "vendor/modules"
    end

    def modules_yml
      "modules.yml"
    end

    def pkg_dir
      "pkg"
    end

    def git_ref(data)
      data["branch"] || data["tag"] || "master"
    end

    def release_name
      [File.basename(Dir.pwd), `git rev-parse HEAD`.chomp].join("-")
    end

    def untar_module(src, dst)
      Dir.exist?(dst) || FileUtils.mkdir_p(dst)
      cwd = Dir.pwd
      Dir.chdir dst
      run "tar zxf #{src}"
      Dir.chdir cwd
    end
  end

  desc "export", "export the terraform module"
  def export
    @release_path = File.join(pkg_dir, [release_name, "tgz"].join("."))

    FileUtils.rm_rf modules_path
    fetch_modules

    Dir.exist?(pkg_dir) || FileUtils.mkdir_p(pkg_dir)
    archive_release
  end
end
