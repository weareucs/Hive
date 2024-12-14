import React from "react";

const Items = () => {
  return (
    <div>
      <section className="product py-5">
        <div className="container px-4 px-lg-5 mt-5">
          <h1 className="mb-4 how">Hive. Products</h1>
          <div className="row gx-4 gx-lg-5 row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 justify-content-start">
            {/* Card 1 */}
            <div className="col mb-5">
              <div className="card h-100 shadow-sm">
                <img
                  className="card-img-top p-3"
                  src="https://5.imimg.com/data5/SELLER/Default/2023/9/346245938/DC/WT/RF/71382662/electrical-switch-board.png"
                  alt="Bee Switch Board"
                />
                <div className="card-body p-4">
                  <div className="text-center">
                    <h5 className="fw-bolder">Bee Switch Board</h5>
                    ₹1799.00 - ₹1999.00
                  </div>
                </div>
                <div className="card-footer p-4 pt-0 border-top-0 bg-transparent">
                  <div className="text-center">
                    <a
                      className="btn btn-outline-dark mt-auto"
                      href="mailto:weareucs.solutions@gmail.com?subject=Enquiry about Bee Switch Board&body=I would like to know more about the Bee Switch Board."
                    >
                      Enquire
                    </a>
                  </div>
                </div>
              </div>
            </div>

            {/* Card 2 */}
            <div className="col mb-5">
              <div className="card h-100 shadow-sm">
                <img
                  className="card-img-top p-3"
                  src="https://img.freepik.com/premium-vector/switch-board-with-buttons-plug-socket-grey-white-color-with-detail-vector-illustration_11410-584.jpg"
                  alt="Bee Extension Board"
                />
                <div className="card-body p-4">
                  <div className="text-center">
                    <h5 className="fw-bolder">Bee Extension Board</h5>
                    ₹1499.00 - ₹1799.00
                  </div>
                </div>
                <div className="card-footer p-4 pt-0 border-top-0 bg-transparent">
                  <div className="text-center">
                    <a
                      className="btn btn-outline-dark mt-auto"
                      href="mailto:weareucs.solutions@gmail.com?subject=Enquiry about Bee Extension Board&body=I would like to know more about the Bee Extension Board."
                    >
                      Enquire
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Items;
