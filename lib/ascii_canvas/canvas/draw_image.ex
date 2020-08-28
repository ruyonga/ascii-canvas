defmodule AsciiCanvas.Canvas.DrawImage do
  @moduledoc false
  alias AsciiCanvas.Utils.Helper
  alias AsciiCanvas.Canvas
  import Mogrify

  @image_name :os.system_time(:millisecond)
              |> Integer.to_string()

  def draw(image_art) do
    image =
      %Mogrify.Image{path: "#{@image_name}.png", ext: "png"}
      |> custom("size", "250x250")
      |> canvas("white")
      |> custom("fill", "black")

    Enum.each(
      image_art,
      fn art ->
        art = Helper.atomize_map_keys(art)

        draw_on_canvas(art, image)
      end
    )

    save_image_url("#{@image_name}.png")
  end

  defp draw_on_canvas(art, image) when is_map_key(art, :fill) and is_map_key(art, :border) do
    rectangle(art)

    Mogrify.Draw.text(
      image,
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.border)
    )
    |> Mogrify.Draw.text(
      art.position.x,
      art.position.y,
      create_fill(art.length, art.fill)
    )
    |> custom(
      "draw",
      "translate 50,50 rotate -90 text #{art.position.x},#{art.position.y} ' #{
        create_vertical_border(4, art.border)
      }'"
    )
    |> Mogrify.Draw.text(
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.border)
    )
    |> create(path: image_path(@image_name))
  end

  defp draw_on_canvas(art, image) when is_map_key(art, :border) do
    rectangle(art)

    Mogrify.Draw.text(
      image,
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.border)
    )
    |> custom(
      "draw",
      "translate 50,50 rotate -90 text #{art.position.x},#{art.position.y} '#{
        create_vertical_border(4, art.border)
      }'"
    )
    |> Mogrify.Draw.text(
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.border)
    )
    |> create(path: image_path(@image_name))
  end

  defp draw_on_canvas(art, image) when is_map_key(art, :fill) do
    rectangle(art)

    Mogrify.Draw.text(
      image,
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.fill)
    )
    |> custom(
      "draw",
      "translate 50,50 rotate -90 text #{art.position.x},#{art.position.y} ' #{
        create_vertical_border(4, art.fill)
      }'"
    )
    |> Mogrify.Draw.text(
      art.position.x,
      art.position.y,
      create_horizontal_border(art.length, art.fill)
    )
    |> create(path: image_path(@image_name))
  end

  def draw_rectangle(r, c, out, inside) do
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

  defp rectangle(art) when is_map_key(art, :fill) and is_map_key(art, :border) do
    draw_rectangle(art.length, art.width, art.border, art.fill)
  end

  defp rectangle(art) when is_map_key(art, :border) do
    draw_rectangle(art.length, art.width, art.border, " ")
  end

  defp rectangle(art) when is_map_key(art, :fill) do
    draw_rectangle(art.length, art.width, " ", art.fill)
  end

  # defp rectangle(_art), do: IO.inspect(nil)

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
