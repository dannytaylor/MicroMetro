-- initialize some test stations and trains to move around
function initTests ()
	-- set up 3 initial stations
	-- connect in order to new route
	-- shape types as numbers to use random
	routes[1] = Route()
	for i = 1, 3 do
		table.insert(stations, Station(love.math.random(20, canvasWidth/2), love.math.random(20, canvasHeight/2), love.math.random(1,3)))
		routes[1].stations[i] = stations[i]
		-- add random # of passengers to a station
		for j = 1, love.math.random(0, 8) do
			-- passenger of random type
			stations[i].passengers[j] = Passenger(math.random(1, 3))
		end
	end
	
	-- 2 test trains
	for i = 1, 3 do
		table.insert(trains, Train(love.math.random(20, canvasWidth-20), love.math.random(20, canvasHeight-160)))
		-- add random number of passengers
		for j = 1, love.math.random(0, 6) do
			trains[i].passengers[j] = Passenger(math.random(1, 3))
		end
	end
end