import React from "react";
import DashboardLayout from "../layouts/Dashboard";
import AuthGate from "../components/Wrappers/AuthGate";
import Personal from "../components/Profiles/Personal_Information/PersonalDashboard";

import { useQuery } from '@apollo/client';
import { MY_PROFILE_QUERY } from "../../apollo/queries/user/myProfile";
import Spinner from "../components/Loading/Spinner";

import "@/styles/pages/Profile.scss";

const Profile: React.FC = () => {
  const { data, loading, error } = useQuery(MY_PROFILE_QUERY);
 
  if (loading) return <Spinner/>;
  if (error) return <p>Error: {error.message}</p>;

  const profileData = data?.myProfile;
  if (!profileData) return null;

  return (
    <AuthGate>
      <DashboardLayout 
        userRole={profileData.user.roleNames}
        activeTab="personal"
      >
          <main>
            <Personal profile={profileData} />
          </main>

      </DashboardLayout>
    </AuthGate>
  );
};

export default Profile;
