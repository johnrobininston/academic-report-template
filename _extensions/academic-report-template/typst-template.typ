
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates


#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  thanks: none,
  keywords: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif", // latex font "libertinus serif"
  fontsize: 10pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "semibold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  heading-size: 0.95em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {

  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
  )

  set par(justify: true)

  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)

  //set heading(numbering: sectionnumbering)
  //if title != none {
  //  align(center)[#block(inset: 2em)[
  //    #set par(leading: heading-line-height)
  //    #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
  //         or heading-color != black or heading-decoration == "underline"
  //         or heading-background-color != none) {
  //      set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
  //      text(size: title-size)[#title]
  //      if subtitle != none {
  //        parbreak()
  //        text(size: subtitle-size)[#subtitle]
  //     }
  //    } else {
  //      text(weight: "bold", size: title-size)[#title]
  //      if subtitle != none {
  //        parbreak()
  //        text(weight: "bold", size: subtitle-size)[#subtitle]
  //      }
  //    }
  //  ]]
  //}

  set heading(numbering: sectionnumbering)
  show heading: it => {
    // Set heading numbering
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(1em, weak: true)
    }
    // Level 1 headings
    set text(size: heading-size, weight: heading-weight, fill: heading-color)
    if it.level == 1 {
      set text(size: heading-size, weight: heading-weight, fill: heading-color)
      smallcaps[  
        #v(20pt, weak: true)
        #number
        #it.body
        #v(15pt, weak: true)
      ]
    } else {
      v(11pt, weak: true)
      number
      let styled = if it.level == 2 { strong } else { emph }
      styled(it.body + [. ])
      h(1em, weak: true)
    }
  }
  
  if title != none {
    align(center)[#block(inset: 2em)[
        #text(weight: "semibold", size: title-size)[
          #title
          #if thanks != none {
            footnote(numbering: "*", thanks)
          }\
          #if subtitle != none {
            text(weight: "regular", style: "italic", size: 0.8em)[#subtitle]
          }
        ]
      ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
      #text(weight: "semibold")[#abstract-title] #h(1em) #abstract \
      #v(0.5em, weak: true) \
      #if keywords != none {
        text(weight: "semibold")[Keywords #h(1em)] 
        text(weight: "regular", style: "italic")[#keywords]
      }
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }

}

#set table(
  inset: 6pt,
  stroke: none
)
