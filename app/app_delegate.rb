class AppDelegate

  PIx = 3.141592653589793
  RADIO = 6371 # Mean radius of Earth in Km

  def convertToRadians(val)
   return val * PIx / 180
  end

  include Math

  def kilometers(place1, place2)
    dlon = convertToRadians(place2.longitude - place1.longitude)
    dlat = convertToRadians(place2.latitude - place1.latitude)

    a = ((sin(dlat / 2) ** 2) + cos(convertToRadians(place1.latitude))) \
           * cos(convertToRadians(place2.latitude)) * (sin(dlon / 2) ** 2);

    angle = 2 * asin(sqrt(a));

    angle * RADIO;
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.makeKeyAndVisible

    @view = UIView.alloc.initWithFrame @window.bounds
    @view.backgroundColor = UIColor.whiteColor

    @window.addSubview @view

    f = CGRectMake 10, 118, 180, 20

    @label = UILabel.alloc.initWithFrame f
    @view.addSubview @label

    @label.text = "Calculating..."

    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.frame = CGRectMake 10, 140, 180, 20
    
    @button.setTitle("Set 2nd Point", forState:UIControlStateNormal)

    @button.addTarget(self , action:"set2nd:", forControlEvents:UIControlEventTouchDown)

    @view.addSubview @button
    f = CGRectMake 10, 165, 180, 20

    @second = UILabel.alloc.initWithFrame f
    @view.addSubview @second

    @second.text = "..."

    @show_km = UILabel.alloc.initWithFrame CGRectMake(10, 190, 180, 20)
    @show_km.text = ""
    @view.addSubview @show_km

    # Create the location manager if this object does not
    # already have one.
    @locationManager = CLLocationManager.alloc.init
 
    @locationManager.delegate = self
    @locationManager.desiredAccuracy = KCLLocationAccuracyKilometer
 
    # Set a movement threshold for new events.
    # @locationManager.distanceFilter = 500
 
    @on_second = false
    @locationManager.startUpdatingLocation

    # alert = UIAlertView.new
    # alert.message = "Tracking location..."
    # alert.show
    true
  end

  def locationManager(manager, didUpdateToLocation: newLocation, fromLocation: oldLocation)
    # If it's a relatively recent event, turn off updates to save power
    eventDate = newLocation.timestamp
    howRecent = eventDate.timeIntervalSinceNow

    # if (abs(howRecent) < 15.0)
    # {
        # NSLog(@"latitude %+.6f, longitude %+.6f\n",

    c = newLocation.coordinate

    if @on_second
      @second.text = "%.4f by %.4f" % [c.latitude, c.longitude]
      @show_km.text = kilometers(@first.coordinate, newLocation.coordinate).to_s
    else
      @first = newLocation
      @label.text = "%.4f by %.4f" % [c.latitude, c.longitude]
    end

    @locationManager.stopUpdatingLocation
  end

  def set2nd(whatever)
    @on_second = true
    @second.text = "Calculating..."

    @locationManager.startUpdatingLocation
  end
end
