defmodule TwittexWeb.TweekHTML do
  use TwittexWeb, :html
  import TwittexWeb.AvatarHelper
  import Phoenix.HTML.Tag, only: [img_tag: 2]

  embed_templates "tweek_html/*"
end
