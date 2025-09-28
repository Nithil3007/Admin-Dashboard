import axios from 'axios';

export interface UserStats {
  user_id: string;
  full_name: string;
  email: string;
  patient_count: number;
  successful_recordings: number;
  failed_recordings: number;
  total_hours: number;
  avg_length_seconds: number;
  avg_file_size_bytes: number;
  tier_name?: string;
}

const adminApi = axios.create({
  baseURL: process.env.NEXT_PUBLIC_ADMIN_API_URL || 'http://localhost:8000',
});

export const getTenantStats = async (): Promise<UserStats[]> => {
  try {
    const response = await adminApi.get<UserStats[]>('/admin/users/stats');
    return response.data;
  } catch (error) {
    console.error('Error fetching tenant stats:', error);
    return [];
  }
};

export const upgradeUserTier = async (userId: string, tierName: string): Promise<any> => {
  const response = await adminApi.post(`/admin/users/${userId}/upgrade`, { tier_name: tierName });
  return response.data;
};
