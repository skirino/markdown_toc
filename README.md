**Table of contents**

- [markdown_toc](./README.md#markdown_toc)
    - [`markdown_toc.rb`](./README.md#markdown_tocrb)
        - [Usage](./README.md#usage)
    - [`insert_markdown_toc.rb`](./README.md#insert_markdown_tocrb)
    - [Example output](./README.md#example-output)

---

# [markdown_toc](https://github.com/skirino/markdown_toc)

Simple Ruby scripts to generate table of contents from markdown files.

## `markdown_toc.rb`

Simple Ruby script to generate table of contents from multiple markdown files.
Links are (basically) compatible with GitHub.

### Usage

Just pass paths to your markdown files to the script.
Output goes to STDOUT.
Run the script with no command line argument to see usage information.

## `insert_markdown_toc.rb`

Simple Ruby script to insert table of contents generated using markdown_toc.rb into a file.
Run the script with no command line argument to see usage information.

## Example output

The table of contents at the top of this file is generated by `./insert_markdown_toc.rb --dest-file=README.md README.md`.
