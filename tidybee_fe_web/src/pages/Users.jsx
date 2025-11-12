import React, { useState, useEffect } from "react";
import axios from "axios";
import toast from "react-hot-toast";
import { API } from "../services/api";

export default function Users() {
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({});
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [searchTerm, setSearchTerm] = useState("");

  const roleMap = {
    1: "Customer",
    2: "Helper",
    3: "Admin",
  };

  const fetchUsers = async (pageNum = 1) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get(
        `${API.USER}/Users?page=${pageNum}&pageSize=10`,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      const usersData = res.data?.data?.users || [];
      const total = res.data?.data?.totalPages || 1;

      setUsers(Array.isArray(usersData) ? usersData : []);
      setTotalPages(total);
      setPage(pageNum);
    } catch (err) {
      console.error(err);
      toast.error("Không thể tải danh sách người dùng!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers(page);
  }, [page]);

  const handleUserClick = async (id) => {
    setDetailLoading(true);
    try {
      const token = localStorage.getItem("token");
      const res = await axios.get(`${API.USER}/Users/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setSelectedUser(res.data?.data);
      setFormData(res.data?.data);
      setEditMode(false);
    } catch (err) {
      console.error(err);
      toast.error("Không thể tải chi tiết user!");
    } finally {
      setDetailLoading(false);
    }
  };

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
    } catch (err) {
      console.error(err);
      toast.error("Không thể xoá người dùng!");
    }
  };

  const handleUpdateUser = async () => {
    try {
      const token = localStorage.getItem("token");
      const payload = {
        email: formData.email || selectedUser.email,
        firstName: formData.firstName || "",
        lastName: formData.lastName || "",
        phoneNumber: formData.phoneNumber || "",
        gender: formData.gender || "other",
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
      console.error(err);
      toast.error("❌ Cập nhật thất bại!");
    }
  };

  const filteredUsers = users.filter((u) => {
    const displayName =
      u.fullName || u.name || `${u.firstName || ""} ${u.lastName || ""}`;
    return (
      displayName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (u.email || "").toLowerCase().includes(searchTerm.toLowerCase())
    );
  });

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">
        👥 Quản lý người dùng
      </h1>

      <div className="mb-4">
        <input
          type="text"
          placeholder="Tìm kiếm người dùng..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-1/3 px-3 py-2 border rounded shadow-sm focus:ring focus:ring-green-200 focus:border-green-400"
        />
      </div>

      {loading ? (
        <div className="flex flex-col items-center justify-center py-20 text-gray-500">
          <p className="italic text-lg">⏳ Đang tải người dùng...</p>
        </div>
      ) : (
        <>
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <table className="min-w-full border-collapse">
              <thead className="bg-green-100 text-gray-700">
                <tr>
                  <th className="p-3 text-left">ID</th>
                  <th className="p-3 text-left">Họ & Tên</th>
                  <th className="p-3 text-left">Email</th>
                  <th className="p-3 text-left">Vai trò</th>
                  <th className="p-3 text-left">Trạng thái</th>
                  <th className="p-3 text-center">Hành động</th>
                </tr>
              </thead>
              <tbody>
                {filteredUsers.length > 0 ? (
                  filteredUsers.map((user, idx) => {
                    const displayName =
                      user.fullName ||
                      user.name ||
                      `${user.firstName || ""} ${user.lastName || ""}`;
                    return (
                      <tr
                        key={user.id}
                        className="border-t hover:bg-gray-50 cursor-pointer"
                        onClick={() => handleUserClick(user.id)}
                      >
                        <td className="p-3">{user.id}</td>
                        <td className="p-3">{displayName || "—"}</td>
                        <td className="p-3">{user.email || "—"}</td>
                        <td className="p-3">{roleMap[user.role] || "—"}</td>
                        <td className="p-3">{user.status || "—"}</td>
                        <td className="p-3 text-center">
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleDeleteUser(user.id);
                            }}
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
                      className="text-center p-4 italic text-gray-500"
                    >
                      Không có người dùng nào.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="flex justify-center gap-3 mt-4">
              <button
                disabled={page <= 1}
                onClick={() => fetchUsers(page - 1)}
                className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
              >
                ← Trước
              </button>
              <span className="text-gray-700">
                Trang {page}/{totalPages}
              </span>
              <button
                disabled={page >= totalPages}
                onClick={() => fetchUsers(page + 1)}
                className="px-3 py-1 bg-gray-200 rounded disabled:opacity-50"
              >
                Sau →
              </button>
            </div>
          )}
        </>
      )}

      {/* Modal chi tiết */}
      {selectedUser && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl shadow-lg w-[500px] max-h-[90vh] overflow-y-auto p-6 relative">
            {detailLoading ? (
              <p>⏳ Đang tải chi tiết...</p>
            ) : !editMode ? (
              <>
                <h2 className="text-xl font-bold mb-4">Chi tiết người dùng</h2>
                <p>
                  <b>Họ & Tên:</b> {selectedUser.firstName}{" "}
                  {selectedUser.lastName}
                </p>
                <p>
                  <b>Email:</b> {selectedUser.email}
                </p>
                <p>
                  <b>SĐT:</b> {selectedUser.phoneNumber || "—"}
                </p>
                <p>
                  <b>Giới tính:</b> {selectedUser.gender || "—"}
                </p>
                <p>
                  <b>Vai trò:</b> {roleMap[selectedUser.role] || "—"}
                </p>
                <p>
                  <b>Trạng thái:</b> {selectedUser.status}
                </p>

                <div className="flex justify-end gap-3 mt-4">
                  <button
                    onClick={() => setEditMode(true)}
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
                  >
                    Chỉnh sửa
                  </button>
                  <button
                    onClick={() => setSelectedUser(null)}
                    className="px-4 py-2 border rounded hover:bg-gray-100"
                  >
                    Đóng
                  </button>
                </div>
              </>
            ) : (
              <>
                <h2 className="text-xl font-bold mb-4">Chỉnh sửa người dùng</h2>
                <label className="block mb-2">
                  <span>Họ</span>
                  <input
                    type="text"
                    value={formData.firstName || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, firstName: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>
                <label className="block mb-2">
                  <span>Tên</span>
                  <input
                    type="text"
                    value={formData.lastName || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, lastName: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>
                <label className="block mb-2">
                  <span>SĐT</span>
                  <input
                    type="text"
                    value={formData.phoneNumber || ""}
                    onChange={(e) =>
                      setFormData({ ...formData, phoneNumber: e.target.value })
                    }
                    className="w-full border rounded px-3 py-2 mt-1"
                  />
                </label>
                <label className="block mb-2">
                  <span>Giới tính</span>
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
                <div className="flex justify-end gap-3 mt-4">
                  <button
                    onClick={handleUpdateUser}
                    className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
                  >
                    Lưu
                  </button>
                  <button
                    onClick={() => setEditMode(false)}
                    className="px-4 py-2 border rounded hover:bg-gray-100"
                  >
                    Huỷ
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
