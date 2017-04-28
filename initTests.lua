-- initialize some test stations and trains to move around a basic random route
function initTests ()
	-- set up 5 initial stations
	-- connect in order to new route
	-- shape types as numbers to use random
	routes[1] = Route()
	for i = 1, 5 do
		table.insert(stations, Station(love.math.random(20, canvasWidth-100), love.math.random(20, canvasHeight-100), love.math.random(1,3)))
		-- add all global stations to this route
		routes[1].stations[i] = stations[i]
		-- add random # of passengers to a station
		for j = 1, love.math.random(0, 8) do
			-- passenger of random type
			stations[i].passengers[j] = Passenger(math.random(1, 3))
		end
	end
	
	-- 1 test train
	table.insert(trains, Train(love.math.random(20, canvasWidth-20), love.math.random(20, canvasHeight-160)))
	-- add random number of passengers
	for j = 1, love.math.random(0, 6) do
		trains[1].passengers[j] = Passenger(math.random(1, 3))
	end

	-- add the route to train 1
	trains[1].route = routes[1]
	-- set the current station to #1 of the route
	trains[1].currentStation = 1

end