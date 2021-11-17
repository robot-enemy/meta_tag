defmodule MetaTag do
  @moduledoc """
  The MetaTagsHelper aids in the creation of page specific meta tags.

  In dev, it will throw an error if the meta_tags function isn't defined in a
  view, but will fail silently in production.
  """
  import Phoenix.HTML.Tag, only: [content_tag: 2, tag: 2]
  require Logger

  @meta_tag_func_name :meta_tags

  defmacro __using__(opts) do
    meta_divider = Keyword.get(opts, :divider, " - ")
    meta_suffix  = Keyword.get(opts, :suffix, "")

    quote do
      @meta_divider unquote(meta_divider)
      @meta_suffix  unquote(meta_suffix)

      import unquote(__MODULE__)
    end
  end

  @doc """
  Generates a set of meta tags for the current page.
  """
  def meta_tags(conn, assigns) do
    action = Phoenix.Controller.action_name(conn)
    view   = Phoenix.Controller.view_module(conn)

    cond do
      action in [:create, :update, :delete] ->
        # create, update, and delete don't require meta tags
        []
      function_exported?(view, @meta_tag_func_name, 2) ->
        # if the meta_tags function exists, build the meta tags
        meta_tags_list = get_meta_tags_from_view_function(view, action, assigns)
        for {name, content} <- meta_tags_list, do: build_meta_tags(name, content)
      true ->
        Logger.warn "missing #{@meta_tag_func_name} function for #{view} #{action} action"
        []
    end
  end

  defp get_meta_tags_from_view_function(view, action, assigns) do
    apply(view, @meta_tag_func_name, [action, assigns])
  end

  defp build_meta_tags(name, nil) do
    Logger.warn("#{name} meta tag has nil value")
  end
  defp build_meta_tags(:title, content) when content == @meta_suffix or @meta_suffix == "" do
    content_tag(:title, content)
  end
  defp build_meta_tags(:title, content) do
    content_tag(:title, "#{content} - #{@meta_suffix}")
  end
  defp build_meta_tags(name, content) do
    tag(:meta, [name: Atom.to_string(name), content: content])
  end

end