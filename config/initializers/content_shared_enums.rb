SHARED_STATES = {
  draft: 0,
  published: 1,
  archived: 2,
  deleted: 3
}.freeze

SHARED_ASSINGABLE_STATES = SHARED_STATES.slice(
  :draft,
  :published,
  :archived
  ).freeze
