import React, { useState, useEffect } from "react";
import axios from "axios";
import toast from "react-hot-toast";
import { API } from "../services/api";

export default function Users() {
  const [users, setUsers] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [loading, setLoading] = useState(true);
  const [selectedUser, setSelectedUser] = useState(null);
  const [formData, setFormData] = useState({});
  const [editMode, setEditMode] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);

  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const roleMap = {
    1: "Customer",
    2: "Helper",
    3: "Admin",
  };

  // Lấy danh sách người dùng
  const fetchUsers = async (page = 1) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const response = await axios.get(
        `${API.USER}/Users?page=${page}&pageSize=10`,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      const usersData = response.data?.data?.users || [];
      const total = response.data?.data?.totalPages || 1;

      setUsers(Array.isArray(usersData) ? usersData : []);
      setTotalPages(total);
    } catch (err) {
      toast.error(
        err.response?.data?.message ||
          "Không thể tải danh sách người dùng! Vui lòng thử lại."
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers(page);
  }, [page]);

  // Xem chi tiết user
  const handleUserClick = async (id) => {
    setDetailLoading(true);
    try {
      const token = localStorage.getItem("token");
      const response = await axios.get(`${API.USER}/Users/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const data = response.data?.data;
      setSelectedUser(data);
      setFormData(data);
      setEditMode(false);
    } catch (err) {
      console.error("❌ Lỗi tải user chi tiết:", err);
      toast.error("Không thể tải thông tin chi tiết!");
    } finally {
      setDetailLoading(false);
    }
  };

  // Xoá user
  const handleDeleteUser = async (id) => {
    if (!window.confirm("Bạn có chắc muốn xoá người dùng này?")) return;

    try {
      const token = localStorage.getItem("token");
      await axios.delete(`${API.USER}/Users/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      toast.success("🗑️ Xoá người dùng thành công!");
      fetchUsers(page);
      setSelectedUser(null);
    } catch (error) {
      console.error("❌ Lỗi khi xoá user:", error);
      toast.error(error.response?.data?.message || "Không thể xoá người dùng!");
    }
  };

  // Cập nhật user
  const handleUpdateUser = async () => {
    try {
      const token = localStorage.getItem("token");
      const payload = {
        email: formData.email || selectedUser.email,
        firstName: formData.firstName || "",
        lastName: formData.lastName || "",
        phoneNumber: formData.phoneNumber || "",
        gender: formData.gender || "other",
        avatar: formData.avatar || "",
        role: Number(formData.role) || 1,
        status: Number(formData.status) || 1,
      };

      await axios.put(`${API.USER}/Users/${selectedUser.id}`, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      });

      toast.success("✅ Cập nhật người dùng thành công!");
      setEditMode(false);
      handleUserClick(selectedUser.id);
    } catch (err) {
      console.error("❌ Cập nhật thất bại:", err.response?.data || err.message);

      if (err.response?.data?.errors) {
        console.group("📋 Validation Errors:");
        Object.entries(err.response.data.errors).forEach(
          ([field, messages]) => {
            console.log(`- ${field}: ${messages.join(", ")}`);
          }
        );
        console.groupEnd();
      }

      toast.error(
        `❌ Cập nhật thất bại: ${
          err.response?.data?.title || "Kiểm tra console để biết chi tiết."
        }`
      );
    }
  };

  // Lọc người dùng
  const filteredUsers = users.filter((u) => {
    const displayName =
      u.fullName ||
      u.name ||
      (u.firstName && u.lastName ? `${u.firstName} ${u.lastName}` : "");
    return (
      displayName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      u.email?.toLowerCase().includes(searchTerm.toLowerCase())
    );
  });

  if (loading)
    return <p className="italic text-gray-500">Đang tải người dùng...</p>;

  return (
    <div className="flex gap-6">
      {/* Danh sách user */}
      <div className="flex-1">
        <h1 className="text-2xl font-bold mb-6 text-gray-800">
          Quản lý người dùng
        </h1>

        <div className="mb-6 flex gap-3 items-center">
          <input
            type="text"
            placeholder="Tìm kiếm người dùng..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-1/3 px-4 py-2 border rounded-lg shadow-sm focus:ring focus:ring-green-200 focus:border-green-400"
          />
        </div>

        <div className="overflow-x-auto bg-white rounded-lg shadow">
          <table className="min-w-full border-collapse">
            <thead className="bg-green-100 text-gray-700">
              <tr>
                <th className="p-3 text-left">ID</th>
                <th className="p-3 text-left">Họ và tên</th>
                <th className="p-3 text-left">Email</th>
                <th className="p-3 text-left">Vai trò</th>
                <th className="p-3 text-left">Trạng thái</th>
                <th className="p-3 text-center">Hành động</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.length > 0 ? (
                filteredUsers.map((user) => {
                  const displayName =
                    user.fullName ||
                    user.name ||
                    (user.firstName && user.lastName
                      ? `${user.firstName} ${user.lastName}`
                      : "—");
                  return (
                    <tr
                      key={user.id}
                      className="border-t hover:bg-gray-50 transition"
                    >
                      <td
                        className="p-3 text-blue-600 cursor-pointer hover:underline"
                        onClick={() => handleUserClick(user.id)}
                      >
                        {user.id}
                      </td>
                      <td className="p-3">{displayName}</td>
                      <td className="p-3">{user.email || "—"}</td>
                      <td className="p-3">{roleMap[user.role] || "—"}</td>
                      <td className="p-3">{user.status || "—"}</td>
                      <td className="p-3 text-center">
                        <button
                          onClick={() => handleDeleteUser(user.id)}
                          className="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600"
                        >
                          Xoá
                        </button>
                      </td>
                    </tr>
                  );
                })
              ) : (
                <tr>
                  <td
                    colSpan="6"
                    className="text-center p-4 text-gray-500 italic"
                  >
                    Không có người dùng nào.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Phân trang */}
        <div className="flex justify-center mt-6 gap-3">
          <button
            disabled={page === 1}
            onClick={() => setPage(page - 1)}
            className="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300 disabled:opacity-50"
          >
            Trước
          </button>
          <span className="font-medium text-gray-700">
            Trang {page} / {totalPages}
          </span>
          <button
            disabled={page >= totalPages}
            onClick={() => setPage(page + 1)}
            className="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300 disabled:opacity-50"
          >
            Sau
          </button>
        </div>
      </div>

      {/* Panel chi tiết */}
      <div className="w-96 bg-white rounded-lg shadow p-6">
        {detailLoading ? (
          <p>Đang tải chi tiết người dùng...</p>
        ) : selectedUser ? (
          <div>
            <h2 className="text-xl font-bold mb-4">Thông tin người dùng</h2>

            {!editMode ? (
              <div className="space-y-2">
                <p>
                  <strong>Họ và tên:</strong> {selectedUser.firstName}{" "}
                  {selectedUser.lastName}
                </p>
                <p>
                  <strong>Email:</strong> {selectedUser.email}
                </p>
                <p>
                  <strong>SĐT:</strong> {selectedUser.phoneNumber || "—"}
                </p>
                <p>
                  <strong>Giới tính:</strong> {selectedUser.gender || "—"}
                </p>
                <p>
                  <strong>Vai trò:</strong> {roleMap[selectedUser.role] || "—"}
                </p>
                <p>
                  <strong>Trạng thái:</strong> {selectedUser.status}
                </p>

                <div className="mt-4 flex gap-3">
                  <button
                    onClick={() => setEditMode(true)}
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
                  >
                    Chỉnh sửa
                  </button>
                  <button
                    onClick={() => handleDeleteUser(selectedUser.id)}
                    className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
                  >
                    Xoá
                  </button>
                </div>
              </div>
            ) : (
              <div className="space-y-3">
                <label className="block">
                  <span className="text-gray-700">Họ</span>
                  <input
                    type="text"
                    value={formData.firstName || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, firstName: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>
                <label className="block">
                  <span className="text-gray-700">Tên</span>
                  <input
                    type="text"
                    value={formData.lastName || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, lastName: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>

                <label className="block">
                  <span className="text-gray-700">SĐT</span>
                  <input
                    type="text"
                    value={formData.phoneNumber || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, phoneNumber: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>

                <label className="block">
                  <span className="text-gray-700">Giới tính</span>
                  <select
                    value={formData.gender || "other"}
                    onChange={(e) =>
                      setFormData({ ...formData, gender: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  >
                    <option value="male">Nam</option>
                    <option value="female">Nữ</option>
                    <option value="other">Khác</option>
                  </select>
                </label>

                <div className="flex gap-3 mt-4">
                  <button
                    onClick={handleUpdateUser}
                    className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
                  >
                    Lưu
                  </button>
                  <button
                    onClick={() => setEditMode(false)}
                    className="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500"
                  >
                    Huỷ
                  </button>
                </div>
              </div>
            )}
          </div>
        ) : (
          <p className="italic text-gray-500">
            Chọn một người dùng để xem chi tiết
          </p>
        )}
      </div>
    </div>
  );
}
