namespace :server do
  desc "stop background server"
  task :stop, :args do |t, args|
    port = ENV['port']
    if port.nil?
      port = ":3000"
    end
    if !port.include?(':')
      port = ':' + port.to_s
    end
    print "Stopping server on port #{port}..."
    pid = `lsof -i #{port} -t`.chomp.to_i
    if pid > 0
      Process.kill 9, pid
      puts "done."
    else
      puts "No server found!"
    end
  end

end
