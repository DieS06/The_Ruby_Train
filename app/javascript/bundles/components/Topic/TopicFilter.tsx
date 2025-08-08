import React from "react";
import { SelectField } from "../Accesible_Assets/SelectField";
import { useEvaluation } from "../../../stores/useEvaluation";

interface Topic { id: number; name: string; }

export const TopicFilter: React.FC<{ topics: Topic[] }> = ({ topics }) => {
  const { filterTopicId, setFilter } = useEvaluation();

  return (
    <SelectField
      label="Topic"
      name="topic"
      selected={filterTopicId ? String(filterTopicId) : ""}
      onChange={(val) => setFilter(val ? Number(val) : null)}
      options={[{ value: "", label: "All" },
        ...topics.map(t => ({ value: String(t.id), label: t.name })),
      ]}
    />
  );
};
