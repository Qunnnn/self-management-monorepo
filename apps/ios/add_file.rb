require 'xcodeproj'

project_path = 'self-management.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

def sync_file(project, target, file_path)
  # Basic logic to find or create groups while avoiding crashing on Synchronized Groups
  # Note: Synchronized Groups (Xcode 16+) technically sync themselves on file system change.
  # This script attempts to link any files that may have drifted.

  path_parts = file_path.split('/')
  file_name = path_parts.last
  group_path = path_parts[0...-1]

  current_group = project.main_group
  
  group_path.each do |folder_name|
    next if folder_name == '.' || folder_name.empty?
    
    # Check if the group exists and is a type we can traverse
    if current_group.respond_to?(:children)
       found_group = current_group.children.find { |c| c.isa == 'PBXGroup' && c.name == folder_name || c.path == folder_name }
       current_group = found_group || current_group.new_group(folder_name)
    elsif current_group.isa == 'PBXFileSystemSynchronizedRootGroup'
       # Inside a synchronized group, Xcode manages children.
       # We stop manual group creation since the filesystem is the source of truth.
       break
    end
  end

  # Find or create file reference
  # If it's in a synchronized group, it should already be there, but let's be safe.
  file_ref = nil
  if current_group.respond_to?(:files)
    file_ref = current_group.files.find { |f| f.path == file_name } || current_group.new_file(file_name)
  end

  if file_ref && !target.source_build_phase.files_references.include?(file_ref)
    target.add_file_references([file_ref])
    puts "Linked: #{file_path}"
  end
end

if ARGV.empty?
  puts "Syncing .swift files from self-management/..."
  Dir.glob("self-management/**/*.swift").each do |file|
    sync_file(project, target, file)
  end
else
  sync_file(project, target, ARGV[0])
end

project.save
puts "Done."
