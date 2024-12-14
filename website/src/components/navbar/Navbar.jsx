import React from "react";
import "../navbar/Navbar.css";

const Navbar = ({ active }) => {
  return (
    <div>
      <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container">
          <a class="navbar-brand" href="#">
            Hive.
          </a>
          <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav"
            aria-controls="navbarNav"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <i class="bi bi-layers"></i>
          </button>
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
              <li class="nav-item">
                <a
                  class="nav-link"
                  style={active == "Homepage" ? { color: "#fbc02d" } : {}}
                  aria-current="page"
                  href="/"
                >
                  Home
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="/products"
                  style={active == "Products" ? { color: "#fbc02d" } : {}}
                >
                  Products
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="/about"
                  style={active == "About" ? { color: "#fbc02d" } : {}}
                >
                  About
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="/contact"
                  style={active == "Contact" ? { color: "#fbc02d" } : {}}
                >
                  Contact
                </a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
  );
};

export default Navbar;
