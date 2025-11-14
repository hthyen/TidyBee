import axios from "axios";

const API_BASE = import.meta.env.VITE_PAYMENT_API;

export const getMyTransactions = async (token, page = 1, pageSize = 50) => {
  const res = await axios.get(`${API_BASE}/payments/my-transactions`, {
    headers: { Authorization: `Bearer ${token}` },
    params: { page, pageSize },
  });
  return {
    transactions: res.data?.data || [],
    page,
    totalPages: 1,
  };
};
