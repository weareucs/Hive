import React from "react";
import Navbar from "../../components/navbar/Navbar";
import Footer from "../../components/footer/Footer";

const About = () => {
  return (
    <div>
      <Navbar active={"About"} />
      <section className="container my-5">
        <div className="d-flex flex-lg-row flex-column justify-content-center align-items-center">
          <div className="">
            <h1 className="text-light mb-5">About Us</h1>
            <p className="head">
              Hive. is a visionary sub-company of ucs, dedicated to simplifying
              your life with innovative smart home solutions. Our smart
              switchboards and extension boards bring intelligence to your
              appliances, empowering you to control them effortlessly from
              anywhere.
            </p>
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
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
};

export default About;
