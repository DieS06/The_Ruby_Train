import React, { useState } from "react";
import api from "@/services/Axios/axios";
import { changeOwnPassword } from "@/services/Auth/authService";

function ChangeOwnPasswordForm() {
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmation, setConfirmation] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      await api.put("/users/password", {
        user: {
          current_password: currentPassword,
          password: newPassword,
          password_confirmation: confirmation,
        },
      });

      setMessage("Password updated successfully.");
      setCurrentPassword("");
      setNewPassword("");
      setConfirmation("");
    } catch (err: any) {
      setMessage("Error updating password.");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="change-password-form">
      <label>
        Current Password
        <input
          type="password"
          value={currentPassword}
          onChange={(e) => setCurrentPassword(e.target.value)}
          required
        />
      </label>

      <label>
        New Password
        <input
          type="password"
          value={newPassword}
          onChange={(e) => setNewPassword(e.target.value)}
          required
        />
      </label>

      <label>
        Confirm Password
        <input
          type="password"
          value={confirmation}
          onChange={(e) => setConfirmation(e.target.value)}
          required
        />
      </label>

      <button type="submit">Update Password</button>

      {message && <p>{message}</p>}
    </form>
  );
}

export default ChangeOwnPasswordForm;

{/* <h2>Change your password</h2>

<%= form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
  <%= render "users/shared/error_messages", resource: resource %>
  <%= f.hidden_field :reset_password_token %>

  <div class="field">
    <%= f.label :password, "New password" %><br />
    <% if @minimum_password_length %>
      <em>(<%= @minimum_password_length %> characters minimum)</em><br />
    <% end %>
    <%= f.password_field :password, autofocus: true, autocomplete: "new-password" %>
  </div>

  <div class="field">
    <%= f.label :password_confirmation, "Confirm new password" %><br />
    <%= f.password_field :password_confirmation, autocomplete: "new-password" %>
  </div>

  <div class="actions">
    <%= f.submit "Change my password" %>
  </div>
<% end %>

<%= render "users/shared/links" %> */}
