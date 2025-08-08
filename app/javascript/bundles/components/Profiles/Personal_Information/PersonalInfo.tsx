import React from "react";
import { Tabs, TabList, Tab, TabPanel } from "react-aria-components"
import "../../../../styles/components/Profile/Personal_Information/PersonalInfo.scss";

import { useQuery } from '@apollo/client';
import { MY_PROFILE_QUERY } from "../../../../apollo/queries/user/myProfile";
import FormGeneral from "../Forms/FormGeneral";
import FormPasswordChange from "../Forms/FormPasswordChange";


const PersonalInformation: React.FC = () => {
  const { data, loading, error } = useQuery(MY_PROFILE_QUERY);
  const profileData = data?.myProfile;

  return (
       <Tabs className="tabs">
        <TabList className="tab-list">
          <Tab id="general" className="tab">General</Tab>
          <Tab id="profile" className="tab">Profile</Tab>
          <Tab id="password" className="tab">Password</Tab>
        </TabList>

        <TabPanel id="general" className="tab-panel">
          <FormGeneral user={profileData.user} onSuccess={() => console.log("Updated")}/>
        </TabPanel>

        <TabPanel id="profile" className="tab-panel">
          <p>Información extendida del perfil (biografía, redes, ocupación...)</p>
        </TabPanel>

        <TabPanel id="password" className="tab-panel">
          <FormPasswordChange />
        </TabPanel>
      </Tabs>
  );
};

export { PersonalInformation };