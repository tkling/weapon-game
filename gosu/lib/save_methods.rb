module SaveMethods
  def save(save_name)
    Dir.mkdir save_dir unless File.directory? save_dir
    save_path = File.join(save_dir, save_name)

    File.write(save_path, savefile_json)
    window.globals.save_data.updated_on = Time.now
    window.globals.save_data.filename = save_name

    @file_saved = true
  end

  def file_saved?
    !!@file_saved
  end

  def save_dir
    @save_dir ||= File.join(window.project_root, 'saves')
  end

  def savefile_json
    JSON.pretty_generate({
      players: window.globals.party.map(&:to_h),
      map: window.globals.map.to_h,
      inventory: window.globals.inventory.map(&:to_h),
      time_played: Time.now - window.globals.session_begin_time + window.globals.save_data.time_played,
   })
  end

  def savefile_paths
    Dir[File.join(save_dir, '*.save')]
  end
end
