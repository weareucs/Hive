import React, { useEffect } from "react";
import Navbar from "../../components/navbar/Navbar";
import Footer from "../../components/footer/Footer";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import logo from "../../assets/logo.png";
import why from "../../assets/why.png";
import s from "../../assets/switch.webp";
import "./Homepage.css";
import Items from "../../components/product/Items";
const Homepage = () => {
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
      <Navbar active={"Homepage"} />

      <section className="container my-5">
        <div className="d-flex flex-lg-row flex-column justify-content-center align-items-center">
          <img src={logo} alt="" className="logo" />
          <div className="">
            <p className="head">
              Hive. is a visionary sub-company of ucs, dedicated to simplifying
              your life with innovative smart home solutions. Our smart
              switchboards and extension boards bring intelligence to your
              appliances, empowering you to control them effortlessly from
              anywhere.
            </p>
            <a
              className="btn btn-dark"
              href="https://github.com/weareucs/Hive/raw/refs/heads/main/app/apk/Hive.apk"
            >
              <i class="bi bi-download"></i> Download APK{" "}
            </a>
            &nbsp;
            {/* <button className="btn btn-outline-dark">
              <i class="bi bi-question-circle"></i> How it works
            </button> */}
          </div>
        </div>
      </section>

      <section className="container-fluid why p-5">
        <div className="my-5">
          <div className="d-flex flex-lg-row flex-column justify-content-between align-items-center">
            <h1 className="d-block d-md-none mb-5 fw-5">Why Choose Us?</h1>
            <ul>
              <li>
                <strong>Affordable Smart Solutions</strong> - We believe that
                smart home technology should be accessible to everyone. Our
                products are competitively priced without compromising on
                quality, ensuring that you get the best value for your
                investment.{" "}
              </li>
              &nbsp;
              <li>
                <strong>Seamless Connectivity</strong> - We ensure that all our
                smart devices are designed to connect effortlessly to your
                existing home network. Our products support the latest Wi-Fi
                technology, ensuring a stable and reliable connection for
                controlling your appliances.
              </li>
              &nbsp;
              <li>
                <strong>Enhanced Energy Efficiency</strong> - Hive. smart
                products empower you to take control of your energy consumption.
              </li>
              &nbsp;
              <li>
                <strong>User-Friendly Technology</strong> - Technology should
                simplify life, not complicate it. That's why Hive. products are
                built with intuitive interfaces and easy setup processes. The
                Hive. App offers a seamless and user-friendly experience,
                allowing you to manage your devices effortlessly.
              </li>
            </ul>
            <img src={why} alt="" className="logo d-md-block d-none" />
          </div>
        </div>
      </section>

      <section class="container py-5 d-flex flex-column flex-lg-row justify-content-around align-items-center">
        <div className="text-center mb-sm-5">
          <h1 className="how fw-5 mb-4 text-light">How It Works!</h1>
        </div>

        <ul class="timeline text-light">
          <li></li>
          <li class="timeline-item mb-5 mt-3">
            <h5 class="">Step 1: Install Hive. smart products.</h5>
          </li>

          <li class="timeline-item mb-5">
            <h5 class="">Step 2: Download the Hive. App.</h5>
          </li>

          <li class="timeline-item mb-5">
            <h5 class="">Step 3: Connect to your devices.</h5>
          </li>

          <li class="timeline-item">
            <h5 class="">
              Step 4: Take control of your home with your fingertips.
            </h5>
          </li>
        </ul>
      </section>

      <Items />
      {/* Map Section */}
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

export default Homepage;
