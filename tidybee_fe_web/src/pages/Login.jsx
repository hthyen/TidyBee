import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import toast from "react-hot-toast";
import logo from "../assets/logo.png";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);

    const loadingToast = toast.loading("Đang đăng nhập...");

    try {
      const response = await axios.post(
        `${import.meta.env.VITE_USER_API}/Auth/login`,
        { email, password }
      );

      const token =
        response.data?.accessToken ||
        response.data?.data?.accessToken ||
        response.data?.token;

      const user = response.data?.user || response.data?.data?.user;

      if (!token) {
        toast.error("Không nhận được accessToken từ server!", {
          id: loadingToast,
        });
        return;
      }

      if (!user || Number(user.role) !== 3) {
        toast.error("Tài khoản này không có quyền Admin!", {
          id: loadingToast,
        });
        return;
      }

      localStorage.setItem("token", token);
      localStorage.setItem("user", JSON.stringify(user));

      toast.success("🎉 Đăng nhập thành công!", { id: loadingToast });
      setTimeout(() => navigate("/admin", { replace: true }), 1000);
    } catch (error) {
      const message =
        error.response?.data?.message ||
        error.response?.data?.error ||
        "Sai email hoặc mật khẩu!";
      toast.error(`❌ ${message}`, { id: loadingToast });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="bg-white rounded-2xl shadow-lg p-10 w-full max-w-md transition-all">
        <div className="flex justify-center mb-6">
          <img
            src={logo}
            alt="TidyBee Logo"
            className="w-28 h-28 object-contain drop-shadow-md"
          />
        </div>

        <h2 className="text-2xl font-bold text-center text-green-600 mb-8">
          Admin Login
        </h2>

        <form onSubmit={handleLogin} className="space-y-5">
          <div>
            <label className="block text-gray-700 mb-2 font-medium">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@tidybee.com"
              className="w-full p-3 border rounded-xl focus:outline-none focus:ring-2 focus:ring-green-400 transition-all"
              required
            />
          </div>

          <div>
            <label className="block text-gray-700 mb-2 font-medium">
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••"
              className="w-full p-3 border rounded-xl focus:outline-none focus:ring-2 focus:ring-green-400 transition-all"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className={`w-full ${
              loading
                ? "bg-gray-400 cursor-not-allowed"
                : "bg-green-500 hover:bg-green-600"
            } text-white p-3 rounded-xl font-semibold transition-all`}
          >
            {loading ? "Đang đăng nhập..." : "Đăng nhập"}
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login;
