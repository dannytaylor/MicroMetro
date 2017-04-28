-- initialize some test stations and trains to move around
function initTests ()
	-- set up 3 initial stations
	-- shape types as numbers to use random
	for i = 1, 3 do
		table.insert(stations, Station(love.math.random(20, 240), love.math.random(20, 160), love.math.random(1,3)))
		-- add random # of passengers to a station
		for j = 1, love.math.random(0, 8) do
			-- passenger of random type
			table.insert(stations[i].passengers,Passenger:new(love.math.random(1,3)))
		end
	end
	
	-- 2 test trains
	for i = 1, 3 do
		table.insert(trains, Train(love.math.random(20, 280), love.math.random(20, 200)))
		-- add random number of passengers
		for j = 1, love.math.random(0, 6) do
			table.insert(trains[i].passengers, Passenger:new(love.math.random(1,3)))
		end
	end
end