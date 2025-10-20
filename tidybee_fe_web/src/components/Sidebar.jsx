import { Link } from "react-router-dom";
import logo from "../assets/logo.png";

export default function Sidebar() {
  return (
    <aside className="w-64 bg-white shadow-md flex flex-col items-center p-6">
      {/* Logo */}
      <div className="w-full flex justify-center mb-10">
        <div className="bg-white p-3 rounded-2xl shadow-lg flex items-center justify-center w-40 h-40">
          <img
            src={logo}
            alt="TidyBee Logo"
            className="w-44 h-44 object-contain scale-140"
          />
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex flex-col space-y-4 w-full">
        <Link
          to="/admin"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Dashboard
        </Link>
        <Link
          to="/admin/users"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Users
        </Link>
        <Link
          to="/admin/services"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Services
        </Link>
        <Link
          to="/admin/orders"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Orders
        </Link>
        <Link
          to="/admin/payments"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Payments
        </Link>
        <Link
          to="/admin/reviews"
          className="text-gray-700 hover:text-green-500 text-lg"
        >
          Reviews
        </Link>
      </nav>
    </aside>
  );
}
