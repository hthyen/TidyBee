// src/pages/Reviews.jsx
import React, { useState } from "react";

export default function Reviews() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCleaner, setFilterCleaner] = useState("");
  const [filterRating, setFilterRating] = useState("");
  const [reviews, setReviews] = useState([
    {
      id: "r001",
      booking: "o001",
      cleaner: "Hằng",
      customer: "Mai",
      rating: 5,
      comment: "Rất sạch, đúng giờ",
      date: "2025-10-15",
    },
    {
      id: "r002",
      booking: "o002",
      cleaner: "Hùng",
      customer: "Lan",
      rating: 4,
      comment: "Ok, nhưng hơi chậm",
      date: "2025-10-16",
    },
    {
      id: "r003",
      booking: "o003",
      cleaner: "Tuấn",
      customer: "Hà",
      rating: 3,
      comment: "Bình thường",
      date: "2025-10-17",
    },
  ]);

  const filteredReviews = reviews.filter(
    (review) =>
      (review.cleaner.toLowerCase().includes(filterCleaner.toLowerCase()) || !filterCleaner) &&
      (filterRating ? review.rating === parseInt(filterRating) : true) &&
      (review.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
        review.comment.toLowerCase().includes(searchTerm.toLowerCase()))
  );

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">Reviews / Ratings</h1>

      {/* Filters */}
      <div className="mb-6 flex flex-wrap gap-4 items-center">
        <input
          type="text"
          placeholder="Search by comment or customer..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="px-4 py-2 border rounded-lg shadow-sm focus:ring focus:ring-green-200 focus:border-green-400"
        />
        <input
          type="text"
          placeholder="Filter by Cleaner"
          value={filterCleaner}
          onChange={(e) => setFilterCleaner(e.target.value)}
          className="px-4 py-2 border rounded-lg"
        />
        <select
          value={filterRating}
          onChange={(e) => setFilterRating(e.target.value)}
          className="border px-4 py-2 rounded-lg"
        >
          <option value="">All Ratings</option>
          <option value="5">5 Stars</option>
          <option value="4">4 Stars</option>
          <option value="3">3 Stars</option>
          <option value="2">2 Stars</option>
          <option value="1">1 Star</option>
        </select>
      </div>

      {/* Reviews Table */}
      <div className="overflow-x-auto bg-white rounded-lg shadow">
        <table className="min-w-full border-collapse">
          <thead className="bg-green-100 text-gray-700">
            <tr>
              <th className="p-3 text-left">ID</th>
              <th className="p-3 text-left">Booking</th>
              <th className="p-3 text-left">Cleaner</th>
              <th className="p-3 text-left">Customer</th>
              <th className="p-3 text-left">Rating</th>
              <th className="p-3 text-left">Comment</th>
            </tr>
          </thead>
          <tbody>
            {filteredReviews.map((r) => (
              <tr key={r.id} className="border-t hover:bg-gray-50 transition">
                <td className="p-3">{r.id}</td>
                <td className="p-3">{r.booking}</td>
                <td className="p-3">{r.cleaner}</td>
                <td className="p-3">{r.customer}</td>
                <td className="p-3">
                  <span
                    className={`px-2 py-1 rounded-full text-sm font-medium ${
                      r.rating >= 4
                        ? "bg-green-100 text-green-700"
                        : r.rating === 3
                        ? "bg-orange-100 text-orange-700"
                        : "bg-red-100 text-red-700"
                    }`}
                  >
                    {r.rating} ★
                  </span>
                </td>
                <td className="p-3">{r.comment}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
