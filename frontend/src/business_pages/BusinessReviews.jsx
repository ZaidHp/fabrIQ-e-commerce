import React, { useEffect, useState } from "react";
import axios from "axios";
import Table from "../business_components/Business_Panel_Table";

const BusinessReviews = () => {
  const [reviews, setReviews] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedFilter, setSelectedFilter] = useState("select");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const business_id = localStorage.getItem("business_id");

  useEffect(() => {
    fetchReviews();
  }, [searchTerm, selectedFilter, currentPage]);

  const fetchReviews = async () => {
    try {
      const response = await axios.get("http://localhost:8080/api/business_reviews", {
        params: {
          business_id,
          search: searchTerm,
          rating: selectedFilter !== "select" ? selectedFilter : undefined,
          page: currentPage,
          limit: 10,
        },
      });
      setReviews(response.data.reviews || []);
      setTotalPages(response.data.totalPages || 1);
    } catch (error) {
      console.error("Error fetching reviews:", error);
    }
  };

  const columns = ["Customer Name", "Rating", "Review", "Reviewed At"];

  return (
    <div className="p-6 w-[85%] mx-auto">
      <h1 className="text-2xl font-bold mb-4">Business Reviews</h1>
      <Table
        columns={columns}
        data={reviews}
        page="BusinessReviews"
        searchTerm={searchTerm}
        onSearchChange={setSearchTerm}
        filters={[
          { label: "Select Rating", value: "select" },
          { label: "⭐ & below", value: "0-1" },
          { label: "⭐ - ⭐⭐", value: "1-2" },
          { label: "⭐⭐ - ⭐⭐⭐", value: "2-3" },
          { label: "⭐⭐⭐ - ⭐⭐⭐⭐", value: "3-4" },
          { label: "⭐⭐⭐⭐ - ⭐⭐⭐⭐⭐", value: "4-5" },
        ]}
        selectedFilter={selectedFilter}
        onFilterChange={setSelectedFilter}
        currentPage={currentPage}
        onPageChange={setCurrentPage}
        totalPages={totalPages}
      />
    </div>
  );
};

export default BusinessReviews;
