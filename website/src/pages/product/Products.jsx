import React from "react";
import Navbar from "../../components/navbar/Navbar";
import Footer from "../../components/footer/Footer";
import Items from "../../components/product/Items";

const Products = () => {
  return (
    <div>
      <Navbar active={"Products"} />

      <Items />

      <Footer />
    </div>
  );
};

export default Products;
