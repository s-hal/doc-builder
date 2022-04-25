local make_sections = (require 'pandoc.utils').make_sections
local section_numbers = {}

function populate_section_numbers (doc)
  function populate (elements)
    for _, el in pairs(elements) do
      if el.t == 'Div' and el.attributes.number then
        section_numbers['#' .. el.attr.identifier] = el.attributes.number
        populate(el.content)
      end
    end
  end

  populate(make_sections(true, nil, doc.blocks))
end

function resolve_section_ref (link)
  if #link.content > 0 or link.target:sub(1, 1) ~= '#' then
    return nil
  end
  local section_number = pandoc.Str("(see Section " .. section_numbers[link.target] .. ")")
  -- x = "(see Section " .. section_number .. ")"
  -- return pandoc.Link({section_number}, link.target, link.title, link.attr)
  return pandoc.Link({section_number}, link.target, link.title, link.attr)
end

return {
  {Pandoc = populate_section_numbers},
  {Link = resolve_section_ref}
}
