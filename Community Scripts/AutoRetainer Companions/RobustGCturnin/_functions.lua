function WalkTo(x, y, z)
    PathfindAndMoveTo(x, y, z, false)
    while (PathIsRunning() or PathfindInProgress()) do
        yield("/wait 0.5")
		--if GetZoneID() == 130 or GetZoneID() == 341 then --130 is uldah. dont need to jump anymore it paths properly. we will test anyways.
		if gachi_jumpy == 1 then --we only doing jumps if we configured for it
		--if GetZoneID() == 341 then --only need to jump in goblet for now
			yield("/gaction jump")
		end
    end
end

function ZoneTransition()
    repeat 
        yield("/wait 0.5")
        yield("/echo Are we ready?")
    until not IsPlayerAvailable()
    repeat 
        yield("/wait 0.5")
        yield("/echo Are we ready? (backup check)")
    until IsPlayerAvailable()
end

function WalkToGC()
    if GetPlayerGC() == 1 then
        yield("/li The Aftcastle")
        ZoneTransition()
        WalkTo(94, 40.5, 74.5)
    elseif GetPlayerGC() == 2 then
        WalkTo(-68.5, -0.5, -8.5)
    elseif GetPlayerGC() == 3 then
        WalkTo(-142.5, 4, -106.5)
    end
end

function TargetedInteract(target)
    yield("/target "..target.." <wait.0.5>")
    yield("/pinteract <wait.1>")
end

function DidWeLoadcorrectly()
	yield("/echo We loaded the functions file successfully!")
end

function CharacterSafeWait()
     yield("/echo 15 second wait for char swap")
	 yield("/wait 15")
	 yield("/waitaddon NamePlate <maxwait.600> <wait.5>")
end

function visland_stop_moving()
 yield("/equipguud")
 yield("/character")
 yield("/pcall Character true 15")
 yield("/wait 0.5")
 yield("/character")
 yield("/pcall Character true 15")
 yield("/wait 3")
 muuv = 1
 muuvX = GetPlayerRawXPos()
 muuvY = GetPlayerRawYPos()
 muuvZ = GetPlayerRawZPos()
 while muuv == 1 do
	yield("/wait 1")
	if muuvX == GetPlayerRawXPos() and muuvY == GetPlayerRawYPos() and muuvZ == GetPlayerRawZPos() then
		muuv = 0
	end
	muuvX = GetPlayerRawXPos()
	muuvY = GetPlayerRawYPos()
	muuvZ = GetPlayerRawZPos()
 end
 yield("/echo movement stopped - time for GC turn ins or whatever")
 yield("/visland stop")
 yield("/vnavmesh stop")
 yield("/wait 3")
end

function return_to_inn()
	yield("/tp New Gridania")
	ZoneTransition()
	yield("/wait 2")
	PathfindAndMoveTo(48.969123840332, -1.5844612121582, 57.311756134033, false)
	visland_stop_moving() --added so we don't accidentally end before we get to the inn person
	yield("/visland exectemponce H4sIAAAAAAAACu3WS4/TMBAA4L9S+RxGfo0fuaEFpBUqLLtIXUAcDPVSS01cEgeEqv53nDSlWxAHUI65eWxnNPlkjb0nr1zlSUm+NGHt6uAWO9ek4LaLFBehrklBVu7HLoY6taT8sCc3sQ0pxJqUe3JPSmnAKsu4LMg7Uj5hgEZKxXhB3pMSNQjGNKpDDmPtr5+Rkom8duvWocv5GNCCLOM3X/k6kTIHNy5tHkK9JmVqOl+Q6zr5xn1Oq5A2r/vv6eXcWH0us93E76eVXF/O/uC27aMUQ9GsIM+rmPwpVfLVOHw67BiDN51v0+Pxnf86BMv4aZy+S3F3Fev1qJFnXobt9ip245/cxi75y/JWLqRzXX30IjaXOfrJt6Hyy7yPHoo/vFGBEGj1kZuCNohIe/7srQwgo8hm7qm4FQObDzQ/cUtpKcU+ztwawQqrZ+3JtCVIjsIctTkwTRH1YG0E5GNOJc7ak2nz3D14Bj9yK1BaS4sDt0VApZWdtSdr3AwYNxbHVmKASmWVPnIzKkFwTs3fvMV8Uf6jt8TcrM3wEjl7SzNyCxDa6rmZTHa8uQWRH4LmzP3rYDPUcr4kp5PWoASXVv0uzYAzIebH339Kfzz8BLifXG8MDQAA")
	visland_stop_moving() --added so we don't accidentally end before we get to the inn person
	yield("/target Antoinaut")
	yield("/wait 0.5")
	yield("/interact")
end

function return_to_fc()
	yield("/tp Estate Hall")
	yield("/wait 1")
	--yield("/waitaddon Nowloading <maxwait.15>")
	yield("/wait 15")
	yield("/waitaddon NamePlate <maxwait.600><wait.5>")
end

function return_fc_entrance()
	yield("/hold W <wait.1.0>")
	yield("/release W")
	yield("/target Entrance <wait.1>")
	yield("/lockon on")
	yield("/automove on <wait.2.5>")
	yield("/automove off <wait.1.5>")
	yield("/hold Q <wait.2.0>")
	yield("/release Q")
end

function return_fc_near_bell()
	yield("/target \"Summoning Bell\"")
	yield("/wait 2")
	--PathfindAndMoveTo(GetObjectRawXPos("Summoning Bell"), GetObjectRawYPos("Summoning Bell"), GetObjectRawZPos("Summoning Bell"), false)
	WalkTo(GetObjectRawXPos("Summoning Bell"), GetObjectRawYPos("Summoning Bell"), GetObjectRawZPos("Summoning Bell"))
	visland_stop_moving() --added so we don't accidentally end before we get to the bell
end

function are_we_dol()
	is_it_dol = false
	yield("Our job is "..GetClassJobId())
	if type(GetClassJobId()) == "number" and GetClassJobId() > 7 and GetClassJobId() < 19 then
		is_it_dol = true
		yield("/echo We are a Disciple of the (H/L)and")
	end
	return is_it_dol
end

function which_cj()
	highest_cj = 0
	highest_cj_level = 0
	yield("Time to figure out which job ID to switch to !")
	for i=0,7 do
		if tonumber(GetLevel(i)) > highest_cj_level then
			highest_cj_level = GetLevel(i)
			highest_cj = i
			yield("/echo Oh my maybe job->"..i.." lv->"..highest_cj_level.." is the highest one?")
		end
	end
	for i=19,29 do
		if tonumber(GetLevel(i)) > highest_cj_level then
			highest_cj_level = GetLevel(i)
			highest_cj = i
			yield("/echo Oh my maybe job->"..i.." lv->"..highest_cj_level.." is the highest one?")
		end
	end
	return tonumber(highest_cj)
end

function job_short(which_cj)
	yield("Time to figure out which job shortname to switch to !")
	if which_cj == -1 then shortjob = "adv" end
	if which_cj == 1 then shortjob = "gld" 
		if GetItemCount(4542) > 0 then
			shortjob = "pld"
		end
	end
	if which_cj == 0 then shortjob = "pgl" 
		if GetItemCount(4543) > 0 then
			shortjob = "mnk"
		end
	end
	if which_cj == 2 then shortjob = "mrd" 
		if GetItemCount(4544) > 0 then
			shortjob = "war"
		end
	end
	if which_cj == 4 then shortjob = "lnc" 
		if GetItemCount(4545) > 0 then
			shortjob = "drg"
		end
	end
	if which_cj == 3 then shortjob = "arc" 
		if GetItemCount(4546) > 0 then
			shortjob = "brd"
		end
	end
	if which_cj == 6 then shortjob = "cnj" 
		if GetItemCount(4547) > 0 then
			shortjob = "whm"
		end
	end
	if which_cj == 5 then shortjob = "thm" 
		if GetItemCount(4548) > 0 then
			shortjob = "blm"
		end
	end
	if which_cj == 19 then shortjob = "rog" 
		if GetItemCount(7886) > 0 then
			shortjob = "nin"
		end
	end
	if which_cj == 20 then shortjob = "mch" end
	if which_cj == 21 then shortjob = "drk" end
	if which_cj == 22 then shortjob = "ast" end
	if which_cj == 23 then shortjob = "sam" end
	if which_cj == 24 then shortjob = "rdm" end
	if which_cj == 25 then shortjob = "blu" end
	if which_cj == 26 then shortjob = "gnb" end
	if which_cj == 27 then shortjob = "dnc" end
	if which_cj == 28 then shortjob = "rpr" end
	if which_cj == 29 then shortjob = "sge" end
	return shortjob
end