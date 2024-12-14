import React from "react";
import Navbar from "../../components/navbar/Navbar";
import logo from "../../assets/logo.png";
import why from "../../assets/why.png";
import s from "../../assets/switch.webp";
import "./Homepage.css";
import Footer from "../../components/footer/Footer";

const Homepage = () => {
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
            <button className="btn btn-dark">
              <i class="bi bi-download"></i> Download APK{" "}
            </button>
            &nbsp;
            <button className="btn btn-outline-dark">
              <i class="bi bi-question-circle"></i> How it works
            </button>
          </div>
        </div>
      </section>

      <section className="container-fluid why p-5">
        <div className="container my-5">
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
          <h1 className="how fw-5 text-light">How It Works!</h1>
          <button className="btn btn-dark">
            <i class="bi bi-download"></i> Download APK{" "}
          </button>
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

      <section class="product py-5">
        <div class="container px-4 px-lg-5 mt-5">
          <h1 className="mb-4">Smart Products</h1>
          <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-start">
            <div class="col mb-5">
              <div class="card h-100">
                <img
                  class="card-img-top p-3"
                  src="https://5.imimg.com/data5/SELLER/Default/2023/9/346245938/DC/WT/RF/71382662/electrical-switch-board.png"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="text-center">
                    <h5 class="fw-bolder">Bee Switch Board</h5>
                    ₹1799.00 - ₹1999.00
                  </div>
                </div>
                <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                  <div class="text-center">
                    <a class="btn btn-outline-dark mt-auto" href="#">
                      View options
                    </a>
                  </div>
                </div>
              </div>
            </div>

            <div class="col mb-5">
              <div class="card h-100">
                <img
                  class="card-img-top"
                  src="https://img.freepik.com/premium-vector/switch-board-with-buttons-plug-socket-grey-white-color-with-detail-vector-illustration_11410-584.jpg"
                  alt="..."
                />
                <div class="card-body p-4">
                  <div class="text-center">
                    <h5 class="fw-bolder">Bee Extension Board</h5>
                    ₹1499.00 - ₹1799.00
                  </div>
                </div>
                <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                  <div class="text-center">
                    <a class="btn btn-outline-dark mt-auto" href="#">
                      View options
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <Footer />
    </div>
  );
};

export default Homepage;
