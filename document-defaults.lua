-- A custom template can omit these commands to use its own table style.
local function shade_cells(row, command)
  local shade = pandoc.RawInline('latex', '\\csname ' .. command .. '\\endcsname{}')
  for _, cell in ipairs(row.cells) do
    local first = cell.contents[1]
    if first and (first.t == 'Plain' or first.t == 'Para') then
      first.content:insert(1, shade)
    else
      cell.contents:insert(1, pandoc.Plain({shade}))
    end
  end
end

function Table(tbl)
  if FORMAT ~= 'latex' and FORMAT ~= 'beamer' then return end
  for _, row in ipairs(tbl.head.rows) do
    shade_cells(row, 'DocBuilderTableHeaderCell')
  end

  local banded = true
  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.head) do
      shade_cells(row, 'DocBuilderTableHeaderCell')
    end
    for _, row in ipairs(body.body) do
      if banded then shade_cells(row, 'DocBuilderTableBandCell') end
      banded = not banded
    end
  end
  return tbl
end

function Pandoc(doc)
  -- Citeproc already uses a final Markdown heading as the bibliography title.
  local last = doc.blocks[#doc.blocks]
  if doc.meta['reference-section-title'] == nil and not (last and last.t == 'Header') then
    doc.meta['reference-section-title'] = 'References'
    return doc
  end
end
