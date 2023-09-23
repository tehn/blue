-- blue
-- @tehn equinox 2023
--
-- e2/e3 only

file = _path.code.."/blue/blue.wav"
rate = 1.0
mix = 0

function init()
	print_info(file)
	-- clear buffer
	softcut.buffer_clear()
	-- buffer_read_mono (file, start_src, start_dst, dur, ch_src, ch_dst)
	softcut.buffer_read_stereo(file,0,1,-1,1,1)

	-- enable voice 1
	softcut.enable(1,1)
	softcut.enable(2,1)
	-- set voice 1 to buffer 1
	softcut.buffer(1,1)
	softcut.buffer(2,2)
	-- set voice 1 level to 1.0
	softcut.level(1,0.8)
	softcut.level(2,0.8)
	-- pan
	softcut.pan(1,-1.0)
	softcut.pan(2,1.0)
	-- voice 1 enable loop
	softcut.loop(1,1)
	softcut.loop(2,1)
	-- set voice 1 loop start to 0
	softcut.loop_start(1,0)
	softcut.loop_start(2,0)
	-- set voice 1 loop end to 2
	softcut.loop_end(1,26.13)
	softcut.loop_end(2,26.13)
	-- set voice 1 position to 1
	softcut.position(1,0)
	softcut.position(2,0)
	-- set voice 1 rate to 1.0
	softcut.rate(1,1.0)
	softcut.rate(2,1.0)
	-- enable voice 1 play
	softcut.play(1,1)
	softcut.play(2,1)

	params:set("softcut_level",0)
	params:set("rev_cut_input",-30)
	params:set("rev_return_level",18)
	params:set("rev_low_time",16)
	params:set("rev_mid_time",8)
	params:set("rev_hf_damping",10000)

	t = 0
	intro = true
	clock.run(screentimer)
	clock.run(d)
end

function screentimer()
	while true do
		clock.sleep(1/15)
		redraw()
	end
end

function d()
	clock.sleep(8.6)
	intro = false
	softcut.loop_start(1,8.6)
	softcut.loop_start(2,8.6)
end



function enc(n,d)
	if n==1 then
	elseif n==2 and not intro then
		rate = util.clamp(rate+d/100,0.75,1.25)
		softcut.rate(1,rate)
		softcut.rate(2,rate)
	elseif n==3 and not intro then
		mix = util.clamp(mix+d/50,0.0,1.0)
		params:set("softcut_level",-(mix*40))
		params:set("rev_cut_input",-30+mix*48)
	end
end

function redraw()
	screen.aa(1)
	screen.clear()
	screen.font_face(14)
	if intro then
		screen.font_size(t*t*t*0.00015)
		screen.move(64,60)
		screen.text_center("blue")
	else
		screen.stroke()
		screen.close()
		screen.level(math.ceil((1.0-mix)*12)+3)
		for i=0,12 do
			screen.arc(math.sin(t*0.1)*3+i*12,36-mix*32.0,6,0,math.pi)
			screen.stroke()
			screen.close()
		end
		for i=0,8 do
			screen.arc(math.sin(t*0.09)*4+i*16,40-mix*32.0,8,0,math.pi)
			screen.stroke()
			screen.close()
		end
		for i=0,6 do
			screen.arc(math.sin(t*0.08)*5+i*22,46-mix*32.0,11,0,math.pi)
			screen.stroke()
			screen.close()
		end
	end
	t = t + rate*rate
	screen.update()
end


function print_info(file)
	if util.file_exists(file) == true then
		local ch, samples, samplerate = audio.file_info(file)
		local duration = samples/samplerate
		print("loading file: "..file)
		print("  channels:\t"..ch)
		print("  samples:\t"..samples)
		print("  sample rate:\t"..samplerate.."hz")
		print("  duration:\t"..duration.." sec")
	else print "read_wav(): file not found" end
end
