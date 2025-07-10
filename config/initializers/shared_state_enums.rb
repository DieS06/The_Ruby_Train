CONTENT_STATES = {
  draft: 0,
  visible: 1,
  archived: 2,
  hidden: 3
}.freeze

CONTENT_TOPIC_STATES = CONTENT_STATES.slice(
  :draft,
  :visible,
  :archived
  ).freeze

GROUP_STATES = {
  open: 0,
  active: 1,
  closed: 2,
  archived: 3
}.freeze

GROUP_MEMBERSHIP_STATES = {
  pending: 0,
  invited: 1,
  joined: 2,
  rejected: 3,
  removed: 4
}.freeze
