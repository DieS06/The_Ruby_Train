import React, { useState } from "react";
import Layout from "../layouts/Layout";
import AuthGate from "../components/Wrappers/AuthGate";
import Personal from "../layouts/PersonalDashboard";
import Progress from "../layouts/ProgressDashboard";
import { SideBar } from "../components/Profiles/SideBar";

import { useQuery } from '@apollo/client';
import { MY_PROFILE_QUERY } from "../../apollo/queries/user/myProfile";
import Spinner from "../components/Loading/Spinner";

import "@/styles/pages/Profile.scss";

const Profile: React.FC = () => {
  const { data, loading, error } = useQuery(MY_PROFILE_QUERY);
  const [activeTab, setActiveTab] = useState<"personal" | "progress">("personal");

  if (loading) return <Spinner/>;
  if (error) return <p>Error: {error.message}</p>;

  const profileData = data?.myProfile;
  if (!profileData) return null;

  // if (!profileData.user.roleNames.includes("student")) {
  // return <Forbidden />;
  // }

  return (
    <AuthGate>
      <Layout>
        <section className="profile-page">
          <SideBar 
          userRole={profileData.user.roleNames[0] ?? "student"} 
          onChange={setActiveTab} />
          <main className="dashboard-content">
            {activeTab === "personal" && <Personal profile={profileData} />}
            {/* {activeTab === "progress" && <Progress progress={progress} />} */}
          </main>
        </section>
      </Layout>
    </AuthGate>
  );
};

export default Profile;
