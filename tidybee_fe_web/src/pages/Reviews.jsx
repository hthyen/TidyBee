import React, { useState } from "react";
import { Search, Filter, Star, MessageSquare, User, Calendar } from "lucide-react";

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
      (review.cleaner.toLowerCase().includes(filterCleaner.toLowerCase()) ||
        !filterCleaner) &&
      (filterRating ? review.rating === parseInt(filterRating) : true) &&
      (review.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
        review.comment.toLowerCase().includes(searchTerm.toLowerCase()))
  );

  const getRatingColor = (rating) => {
    if (rating >= 4) return "bg-green-100 text-green-700";
    if (rating === 3) return "bg-yellow-100 text-yellow-700";
    return "bg-red-100 text-red-700";
  };

  const renderStars = (rating) => {
    return Array.from({ length: 5 }, (_, i) => (
      <Star
        key={i}
        className={`w-4 h-4 ${
          i < rating ? "text-yellow-400 fill-yellow-400" : "text-gray-300"
        }`}
      />
    ));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Reviews / Ratings
        </h1>
        <p className="text-gray-600">
          Xem và quản lý tất cả các đánh giá và xếp hạng trong hệ thống
        </p>
      </div>

      {/* Filters */}
      <div className="bg-white p-6 rounded-xl shadow-soft border border-gray-100">
        <div className="flex flex-col sm:flex-row gap-4">
          {/* Search */}
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Tìm kiếm
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Search className="h-5 w-5 text-gray-400" />
              </div>
              <input
                type="text"
                placeholder="Tìm kiếm theo khách hàng hoặc bình luận..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 placeholder-gray-400"
                aria-label="Search reviews"
              />
            </div>
          </div>

          {/* Filter by Cleaner */}
          <div className="sm:w-64">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Lọc theo Cleaner
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Filter className="h-5 w-5 text-gray-400" />
              </div>
              <input
                type="text"
                placeholder="Tên cleaner..."
                value={filterCleaner}
                onChange={(e) => setFilterCleaner(e.target.value)}
                className="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 placeholder-gray-400"
                aria-label="Filter by cleaner"
              />
            </div>
          </div>

          {/* Filter by Rating */}
          <div className="sm:w-48">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Lọc theo Rating
            </label>
            <select
              value={filterRating}
              onChange={(e) => setFilterRating(e.target.value)}
              className="block w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-gray-900 bg-white"
              aria-label="Filter by rating"
            >
              <option value="">Tất cả Ratings</option>
              <option value="5">5 Sao</option>
              <option value="4">4 Sao</option>
              <option value="3">3 Sao</option>
              <option value="2">2 Sao</option>
              <option value="1">1 Sao</option>
            </select>
          </div>
        </div>
      </div>

      {/* Reviews Table */}
      <div className="bg-white rounded-xl shadow-soft border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  ID
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Booking
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Cleaner
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Customer
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Rating
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Comment
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Ngày
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredReviews.length > 0 ? (
                filteredReviews.map((r) => (
                  <tr
                    key={r.id}
                    className="hover:bg-gray-50 transition-colors"
                  >
                    <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {r.id}
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-600">
                      <div className="flex items-center gap-2">
                        <Calendar className="w-4 h-4 text-gray-400" />
                        {r.booking}
                      </div>
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                      <div className="flex items-center gap-2">
                        <User className="w-4 h-4 text-gray-400" />
                        {r.cleaner}
                      </div>
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                      <div className="flex items-center gap-2">
                        <User className="w-4 h-4 text-gray-400" />
                        {r.customer}
                      </div>
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap">
                      <div className="flex items-center gap-2">
                        <span
                          className={`inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ${getRatingColor(
                            r.rating
                          )}`}
                        >
                          <Star className="w-3.5 h-3.5 fill-current" />
                          {r.rating}
                        </span>
                        <div className="flex items-center gap-0.5">
                          {renderStars(r.rating)}
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-4 text-sm text-gray-600">
                      <div className="flex items-start gap-2 max-w-md">
                        <MessageSquare className="w-4 h-4 text-gray-400 mt-0.5 flex-shrink-0" />
                        <span className="line-clamp-2">{r.comment}</span>
                      </div>
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(r.date).toLocaleDateString("vi-VN")}
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td
                    colSpan="7"
                    className="px-4 py-12 text-center text-gray-500"
                  >
                    <Star className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                    <p className="font-medium">Không tìm thấy reviews nào.</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Summary Stats */}
      {filteredReviews.length > 0 && (
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div className="bg-white p-4 rounded-xl shadow-soft border border-gray-100">
            <p className="text-sm font-medium text-gray-600 mb-1">
              Tổng số reviews
            </p>
            <p className="text-2xl font-bold text-gray-900">
              {filteredReviews.length}
            </p>
          </div>
          <div className="bg-white p-4 rounded-xl shadow-soft border border-gray-100">
            <p className="text-sm font-medium text-gray-600 mb-1">
              Rating trung bình
            </p>
            <p className="text-2xl font-bold text-gray-900">
              {(
                filteredReviews.reduce((sum, r) => sum + r.rating, 0) /
                filteredReviews.length
              ).toFixed(1)}{" "}
              <Star className="w-5 h-5 inline-block text-yellow-400 fill-yellow-400" />
            </p>
          </div>
          <div className="bg-white p-4 rounded-xl shadow-soft border border-gray-100">
            <p className="text-sm font-medium text-gray-600 mb-1">
              Reviews 5 sao
            </p>
            <p className="text-2xl font-bold text-green-600">
              {filteredReviews.filter((r) => r.rating === 5).length}
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
