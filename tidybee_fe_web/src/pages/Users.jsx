import React, { useState, useEffect } from "react";
import axios from "axios";

export default function Users() {
  const [users, setUsers] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [selectedUser, setSelectedUser] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const roleMap = {
    1: "Customer",
    2: "Helper",
    3: "Admin",
  };

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const token = localStorage.getItem("token");
        if (!token) {
          setError("❌ Chưa đăng nhập!");
          setLoading(false);
          return;
        }

        const response = await axios.get(
          "http://3.107.252.215:8080/api/Users",
          { headers: { Authorization: `Bearer ${token}` } }
        );

        const data = response.data?.data?.users || [];
        setUsers(Array.isArray(data) ? data : []);
      } catch (err) {
        setError(
          err.response?.data?.message ||
            err.message ||
            "Không thể tải danh sách người dùng!"
        );
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  const handleUserClick = async (id) => {
    setDetailLoading(true);
    try {
      const token = localStorage.getItem("token");
      const response = await axios.get(
        `http://3.107.252.215:8080/api/Users/${id}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setSelectedUser(response.data.data);
    } catch (err) {
      console.error("❌ Lỗi tải user chi tiết:", err);
      alert("Không thể tải thông tin chi tiết!");
    } finally {
      setDetailLoading(false);
    }
  };

  if (loading)
    return <p className="text-gray-500 italic">Đang tải danh sách người dùng...</p>;

  if (error) return <p className="text-red-600 font-semibold">⚠️ {error}</p>;

  const filteredUsers = users
    .filter((user) => user.role === 1 || user.role === 2)
    .filter((user) => {
      const displayName =
        user.fullName ||
        user.name ||
        (user.firstName && user.lastName ? `${user.firstName} ${user.lastName}` : "");
      return (
        displayName.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (user.email && user.email.toLowerCase().includes(searchTerm.toLowerCase()))
      );
    });

  return (
    <div className="flex gap-6">
      {/* Bảng danh sách người dùng */}
      <div className="flex-1">
        <h1 className="text-2xl font-bold mb-6 text-gray-800">Quản lý người dùng</h1>

        <div className="mb-6 flex justify-between items-center">
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
                    <tr key={user.id} className="border-t hover:bg-gray-50 transition">
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
                    </tr>
                  );
                })
              ) : (
                <tr>
                  <td colSpan="5" className="text-center p-4 text-gray-500">
                    Không có người dùng nào.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Panel chi tiết user */}
      <div className="w-96 bg-white rounded-lg shadow p-6">
        {detailLoading ? (
          <p>Đang tải chi tiết người dùng...</p>
        ) : selectedUser ? (
          <div className="space-y-2">
            <h2 className="text-xl font-bold mb-4">Thông tin người dùng</h2>
            <p><strong>ID:</strong> {selectedUser.id}</p>
            <p><strong>Họ và tên:</strong> {selectedUser.firstName} {selectedUser.lastName}</p>
            <p><strong>Email:</strong> {selectedUser.email}</p>
            <p><strong>Số điện thoại:</strong> {selectedUser.phoneNumber || "—"}</p>
            <p><strong>Vai trò:</strong> {roleMap[selectedUser.role] || "—"}</p>
            <p><strong>Trạng thái:</strong> {selectedUser.status}</p>
            <p><strong>Ngày sinh:</strong> {selectedUser.dateOfBirth?.split("T")[0] || "—"}</p>
            <p><strong>Giới tính:</strong> {selectedUser.gender || "—"}</p>
            <p><strong>Ngày tạo:</strong> {selectedUser.createdAt?.split("T")[0]}</p>
            <p><strong>Ngày cập nhật:</strong> {selectedUser.updatedAt?.split("T")[0]}</p>
            <p><strong>Lần đăng nhập cuối:</strong> {selectedUser.lastLoginAt?.split("T")[0]}</p>
          </div>
        ) : (
          <p className="text-gray-500 italic">Chọn một người dùng để xem chi tiết</p>
        )}
      </div>
    </div>
  );
}
