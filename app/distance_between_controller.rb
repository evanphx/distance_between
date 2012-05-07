class DistanceBetweenViewController < UIViewController
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

  def loadView
    self.view = UIView.alloc.init
  end

  def viewDidLoad
    @height = 70
    view.backgroundColor = UIColor.whiteColor
    @mapView = MKMapView.alloc.initWithFrame(view.bounds)
    @mapView.setShowsUserLocation("YES")
    view.addSubview @mapView

    f = CGRectMake 10, 20, 300, 20

    @label = UILabel.alloc.initWithFrame f
    view.addSubview @label

    @label.text = "Calculating..."

    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.frame = CGRectMake 10, 50, 300, 20

    @button.setTitle("Find Me", forState:UIControlStateNormal)

    @button.addTarget(self , action:"set2nd:", forControlEvents:UIControlEventTouchDown)

    view.addSubview @button

    # @map = MKMapView
    # view.addSubview @map
    # Create the location manager if this object does not
    # already have one.
    @locationManager = CLLocationManager.alloc.init

    @locationManager.delegate = self
    @locationManager.desiredAccuracy = KCLLocationAccuracyKilometer

    @locationManager.startUpdatingLocation

    true
  end

  def locationManager(manager, didUpdateToLocation: newLocation, fromLocation: oldLocation)
    # If it's a relatively recent event, turn off updates to save power
    eventDate = newLocation.timestamp
    howRecent = eventDate.timeIntervalSinceNow

    @label.text = "Found you!"
    @button.setTitle("Find Me", forState:UIControlStateNormal)

    c = newLocation.coordinate
    setRegion(c)
    f = CGRectMake 10, (@height += 30), 300, 20
    @second = UILabel.alloc.initWithFrame f
    view.addSubview @second
    @second.text = "%.4f by %.4f" % [c.latitude, c.longitude]
    @second.text += " %.2f" %  kilometers(@first.coordinate, newLocation.coordinate).to_s + "Km" if @first

    @first = newLocation
    @locationManager.stopUpdatingLocation
  end

  def setRegion(c)
    @span    = MKCoordinateSpan.new(0.02, 0.02)
    @region  = MKCoordinateRegion.new(c, @span)
    @mapView.setRegion(@region, animated: "YES")
  end

  def set2nd(whatever)
    @label.text = "Calculating..."

    @locationManager.startUpdatingLocation
  end

end



