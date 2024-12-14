import React, { useEffect } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css"; // Import Leaflet CSS
import Navbar from "../../components/navbar/Navbar";
import Footer from "../../components/footer/Footer";

const Contact = () => {
  useEffect(() => {
    const map = L.map("map").setView([23.0054366, 72.6185031], 13); // London coordinates

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    const marker = L.marker([23.0054366, 72.6185031]).addTo(map);

    marker.bindPopup("<b>Location</b><br>Ahmedabad, Gujarat").openPopup();

    return () => {
      map.remove();
    };
  }, []);
  return (
    <div>
      <Navbar active={"Contact"} />
      <section className="contact py-5 bg-light">
        <div className="container px-4 px-lg-5">
          <h1 className=" mb-4">Contact Us</h1>
          <div className="row gx-4 gx-lg-5 align-items-center">
            <div className="col-md-6 mb-5">
              <p>
                <strong>Email:</strong>{" "}
                <a href="mailto:weareucs.solutions@gmail.com">
                  weareucs.solutions@gmail.com
                </a>
              </p>
              <p>
                <strong>Phone:</strong>{" "}
                <a href="tel:+1234567890">+91 9537527143</a>
                ,&nbsp;
                <a href="tel:+1234567890">+91 9313181776</a>,&nbsp;
                <a href="tel:+1234567890">+91 9925249492</a>
              </p>
              <p>Feel free to reach out to us for any inquiries or support.</p>
            </div>
            <div className="col-md-6 mb-5">
              <div id="map" style={{ height: "400px", width: "100%" }}></div>
            </div>
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
};

export default Contact;
