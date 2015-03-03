# MMTApp
Test Application - This is best viewed on IOS 8

iBeacon Sample project:

Build a small app that listens for iBeacons and displays unique content to the user when near a particular beacon. You'll need to simulate different iBeacons using an iOS device or a computer that has Bluetooth. There should be plenty of resources online on how to set that up.

iBeacons are unique to their uuid, major, and minor numbers (together, a UMM). Use the following UMMs for this project:

                                UUID   Major   Minor

B7499731-06DF-4D2B-9525-C5C790C73D69    1000       1

B7499731-06DF-4D2B-9525-C5C790C73D69    1000       2

B7499731-06DF-4D2B-9525-C5C790C73D69    1000       3


The app should retrieve content from the following mock API:

https://s3.amazonaws.com/ibeacon-mock/{uuid}/{major}/{minor}.json

There's content for each of the three UMMs above; I just took it from the iTunes charts. For example, the first entry in the table above would be retrieved with:

https://s3.amazonaws.com/ibeacon-mock/B7499731-06DF-4D2B-9525-C5C790C73D69/1000/1.json

Displaying the content is up to you; We'll be paying more attention to the code than the front-end design so don't spend too much time making it look pretty.

In addition to displaying the right content, the user should be notified when near a beacon, i.e. using an alert. The content can be displayed within the alert if you wish. If multiple beacons are present, the user should be notified only for the nearest beacon. The alert should only display once after approaching a particular beacon, so after dismissing the alert the user should not be notified again for that beacon unless they move closer to a different beacon.
