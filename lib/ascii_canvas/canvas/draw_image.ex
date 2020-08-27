defmodule AsciiCanvas.Canvas.DrawImage do
  @moduledoc false
  alias AsciiCanvas.Utils.Helper
  alias AsciiCanvas.Canvas
  import Mogrify

  @image_name :os.system_time(:millisecond) |> Integer.to_string()

  # My research show usage of imagemick functionality could help in the production of the image

  def draw(image_params) do
    image =
      %Mogrify.Image{path: "#{@image_name}.png", ext: "png"}
      |> custom("size", "250x250")
      |> canvas("white")
      |> custom("fill", "black")

    Enum.each(image_params, fn art ->
      on_canvas_draw(image, art)
    end)

    save_image_url("#{@image_name}.png")
  end

  defp on_canvas_draw( image,
         %{
            "length" => _length,
            "width" => _width,
            "border" => _border,
            "position" => _position} =
           art
       ) do

    draw_on_console(art)
    params = Helper.atomize_map_keys(art)

    Mogrify.Draw.text(
      image,
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.border)
    )
    |> custom( "draw", "translate 50,50 rotate -90 text #{params.position.x},#{params.position.y} '#{create_vertical_border(4, params.border)}'")
    |> Mogrify.Draw.text(
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.border)
    ) |> create(path: image_path(@image_name))
  end

  defp on_canvas_draw( image, %{"length" => _length, "width" => _width, "fill" => _fill, "position" => _position} = art ) do
    draw_on_console(art)

    params = Helper.atomize_map_keys(art)

    Mogrify.Draw.text(
      image,
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.fill)
    )
    |> custom(
      "draw",
      "translate 50,50 rotate -90 text #{params.position.x},#{params.position.y} ' #{
        create_vertical_border(4, params.fill)
      }'")
    |> Mogrify.Draw.text(
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.fill)
    )
    |> create(path: image_path(@image_name))
    |> IO.inspect()

  end

  defp on_canvas_draw( image,
         %{
           "length" => _length,
           "width" => _width,
           "fill" => _fill,
           "border" => _border,
           "position" => _position
         } = art
       ) do

    draw_on_console(art)
    params = Helper.atomize_map_keys(art)

    Mogrify.Draw.text(
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.border)
    )
    |> Mogrify.Draw.text(
      image,
      params.position.x,
      params.position.y,
      create_fill(params.length, params.fill)
    )
    |> custom(
      "draw",
      "translate 50,50 rotate -90 text #{params.position.x},#{params.position.y} ' #{
        create_vertical_border(4, params.border)
      }'"
    )
    |> Mogrify.Draw.text(
      image,
      params.position.x,
      params.position.y,
      create_horizontal_border(params.length, params.border)
    )
    |> create(path: image_path(@image_name))
    |> IO.inspect()
  end

  @doc """
   Output individual ascii characters in the console.
  """
  def draw_on_console(image_params) do
    image_params |> Enum.each(fn x -> rectangle(x) end)
  end

  def draw_rectangle(r, c, out, inside) do
    In
    Enum.each(
      1..r,
      fn x ->
        Enum.each(
          1..c,
          fn i ->
            if(x == 1 || x == r || i == 1 || i == c) do
              draw_character(out)
            else
              draw_character(inside)
            end
          end
        )

        IO.puts("")
      end
    )
  end

  defp rectangle(%{"length" => length, "width" => width, "border" => border}), do: draw_rectangle(length, width, border, " ")
  defp rectangle(%{"length" => length, "width" => width, "fill" => fill}), do: draw_rectangle(length, width, " ", fill)
  defp rectangle(%{"length" => length, "width" => width, "border" => border, "fill" => fill}), do: draw_rectangle(length, width, border, fill)
  defp rectangle(_art), do: nil

  defp save_image_url(url), do: Canvas.create_image(%{"url" => url})

  defp create_horizontal_border(width, c),
    do:
      Enum.into(1..width, [], fn _x -> c end)
      |> List.to_string()

  defp create_vertical_border(height, c),
    do:
      Enum.into(1..height, [], fn _x -> c end)
      |> List.to_string()

  defp create_fill(width, fill),
    do:
      Enum.into(1..(width - 2), [], fn _x -> fill end)
      |> List.to_string()

  defp draw_character(c), do: IO.write(c)

  defp image_path(name), do: to_string(:code.priv_dir(:ascii_canvas)) <> "/images/#{name}.png"
end
