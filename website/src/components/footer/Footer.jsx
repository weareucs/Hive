import React from "react";

const Footer = () => {
  return (
    <div>
      <footer class="text-center text-lg-start bg-body-tertiary text-muted">
        <section class="d-flex justify-content-center justify-content-lg-between p-4 border-bottom">
          <div class="me-5 d-none d-lg-block">
            <span>Get connected with us on social networks:</span>
          </div>

          <div>
            <a
              href="https://www.instagram.com/we.are.ucs?utm_source=qr&igsh=c2x2cXhuNm8xb2xi"
              target="_blank"
              class="text-reset"
            >
              <i class="bi bi-instagram"></i>
            </a>
          </div>
        </section>

        <section class="">
          <div class="container text-center text-md-start mt-5">
            <div class="row mt-3">
              <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                <h6 class="fw-bold mb-4">Hive.</h6>
                <p>
                  Dedicated to simplifying your life with innovative smart home
                  solutions.
                </p>
              </div>

              <div class="col-md-2 col-lg-2 col-xl-2 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Products</h6>
                <p>
                  <a
                    href="mailto:weareucs.solutions@gmail.com?subject=Enquiry about Bee Switch Board&body=I would like to know more about the Bee Switch Board."
                    class="text-reset"
                  >
                    Bee Switch Boards
                  </a>
                </p>
                <p>
                  <a
                    href="mailto:weareucs.solutions@gmail.com?subject=Enquiry about Bee Extension Board&body=I would like to know more about the Bee Extension Board."
                    class="text-reset"
                  >
                    Bee Extension Boards
                  </a>
                </p>
              </div>

              <div class="col-md-3 col-lg-2 col-xl-2 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Useful links</h6>
                <p>
                  <a href="#!" class="text-reset">
                    About
                  </a>
                </p>
                <p>
                  <a href="#!" class="text-reset">
                    Contact
                  </a>
                </p>
                <p>
                  <a
                    href="mailto:weareucs.solutions@gmail.com"
                    class="text-reset"
                  >
                    Help
                  </a>
                </p>
              </div>

              <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Contact</h6>
                <p>
                  <i class="bi bi-geo-alt-fill"></i> Ahmedabad, Gujarat, India,
                  380026
                </p>
                <p>
                  <i class="bi bi-envelope me-2"></i>
                  weareucs.solutions@gmail.com
                </p>
                <p>
                  <i class="bi bi-phone me-2"></i> +91 9537527143
                </p>
                <p>
                  <i class="bi bi-phone me-2"></i> +91 9313181776
                </p>
                <p>
                  <i class="bi bi-phone me-2"></i> +91 9925249492
                </p>
              </div>
            </div>
          </div>
        </section>

        <div className="d-flex justify-content-between">
          <div class="text-center p-4">
            © 2024 Copyright: &nbsp;
            <a class="text-reset fw-bold" href="https://hivebyucs.vercel.app/">
              Hive.
            </a>
          </div>
          <div class="text-center p-4">
            Developed & Maintained: &nbsp;
            <a
              class="text-reset fw-bold"
              target="_blank"
              href="https://ud15.netlify.app/"
            >
              ud.dev
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Footer;
