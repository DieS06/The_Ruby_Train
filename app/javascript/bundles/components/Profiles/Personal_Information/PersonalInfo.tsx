import React from "react";
import { Tabs, TabList, Tab, TabPanel } from "react-aria-components"
import { Input } from "../../Accesible_Assets/Input";
import "../../../../styles/components/Profile/Personal_Information/PersonalInfo.scss";

const PersonalInformation: React.FC = () => {

  return (
       <Tabs className="tabs">
        <TabList className="tab-list">
          <Tab id="general" className="tab">General</Tab>
          <Tab id="profile" className="tab">Profile</Tab>
          <Tab id="settings" className="tab">Password</Tab>
        </TabList>

        <TabPanel id="general" className="tab-panel">

        </TabPanel>

        <TabPanel id="profile" className="tab-panel">
          <p>Información extendida del perfil (biografía, redes, ocupación...)</p>
        </TabPanel>

        <TabPanel id="password" className="tab-panel">
          
        </TabPanel>
      </Tabs>
  );
};

export { PersonalInformation };