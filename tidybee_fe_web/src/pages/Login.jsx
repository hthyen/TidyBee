import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import logo from "../assets/logo.png";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post(
        "http://3.107.252.215:8080/api/Auth/login",
        { email, password }
      );

      // Lấy token từ nhiều cấu trúc trả về
      const token =
        response.data?.accessToken ||
        response.data?.data?.accessToken ||
        response.data?.token;

      // Lấy user từ nhiều cấu trúc trả về
      const user = response.data.user || response.data?.data?.user;

      if (!token) {
        alert("Không nhận được accessToken từ server!");
        return;
      }

      if (!user || Number(user.role) !== 3) {
        alert("❌ Bạn không có quyền Admin!");
        return;
      }

      // Lưu token và user vào localStorage
      localStorage.setItem("token", token);
      localStorage.setItem("user", JSON.stringify(user));

      alert("🎉 Đăng nhập thành công!");
      setTimeout(() => navigate("/admin", { replace: true }), 100);
    } catch (error) {
      // Lấy message lỗi từ server hoặc fallback
      const message =
        error.response?.data?.message ||
        error.response?.data?.error ||
        "Sai email hoặc mật khẩu!";
      alert(message);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="bg-white rounded-2xl shadow-lg p-10 w-full max-w-md">
        <div className="flex justify-center mb-6">
          <img
            src={logo}
            alt="TidyBee Logo"
            className="w-30 h-30 object-contain scale-140"
          />
        </div>

        <h2 className="text-2xl font-bold text-center text-green-600 mb-8">
          Admin Login
        </h2>

        <form onSubmit={handleLogin} className="space-y-5">
          <div>
            <label className="block text-gray-700 mb-2">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@tidybee.com"
              className="w-full p-3 border rounded-xl focus:outline-none focus:ring-2 focus:ring-green-400"
              required
            />
          </div>

          <div>
            <label className="block text-gray-700 mb-2">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••"
              className="w-full p-3 border rounded-xl focus:outline-none focus:ring-2 focus:ring-green-400"
              required
            />
          </div>

          <button
            type="submit"
            className="w-full bg-green-500 hover:bg-green-600 text-white p-3 rounded-xl font-semibold transition"
          >
            Log in
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login;
