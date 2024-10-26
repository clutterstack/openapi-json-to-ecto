# Ecto embedded schemas from a JSON OpenAPI spec (at least the Fly Machines one)

Fair warning: This is spaghetti mixed with salad, and it hasn't been used much. I used Claude iteratively (plus ChatGPT and Gemini occasionally) to push my way through this. _Also,_ it wasn't made from first principles. Claude and I reverse-engineered a specific API's OpenAPI spec from [doc.machines.dev](https://docs.machines.dev), so who knows if it generalizes to any other API!

Unless I go in and clean up the code, it may also be hard to learn useful lessons from. 

You can read more about the fun I had building this at https://clutterstack.com/posts/2024-10-24-llm-observations.

## Reasons for building this

* Sheer mule-headedness (mainly)
* To practice LLM prompting and generally finding ways to augment my work with models
* To learn about Elixir and Ecto
* To let me validate request bodies I pass as maps to [Christian Kreiling](https://github.com/ckreiling)'s [Elixir client for the Fly Machines API](https://github.com/ckreiling/fly_machines).

## What it does (if it's working right)

* Takes a filename where the JSON spec should be found, and an output directory name
* For each component/schema it finds in the spec, writes a schema module file with an embedded schema and changeset into the specified output directory. 

## Usage

```
mix build_schemas <input-file> <output-dir>
```

The input file must contain an OpenApi spec in JSON format. It's conceivable that the input file has to be the specific `spec.json` file I pulled from https://docs.machines.dev this week.


## What to do with the output

Copy the generated schema files into the Elixir project you want to use it in, somewhere under `lib/`. You'll need Ecto in the project to get anything out of this.

As an example, here's a validation function I use with them:

```elixir
  def validate_schema(body, schema_module_name) do
    changeset = schema_module_name.changeset(struct(schema_module_name), body)
    case changeset.valid? do
      true ->
        {:ok, changeset}
      false ->
        {:error, Ecto.Changeset.traverse_errors(changeset, &(&1))}
    end
  end
```

You feed the `validate_schema/2` function two arguments: a map of the data you want to send in the request body, and the Ecto schema module name the `body` is meant to conform to. 

The function, in turn, feeds two arguments to the corresponding schema module's `changeset/2` function: 
* the schema struct belonging to that module (provided by behind-the-scenes code we get from `use Ecto.Schema`), which we access here using [`Kernel.struct/2`](https://hexdocs.pm/elixir/Kernel.html#struct/2), and 
* the attributes we want to put into the changeset&mdash;the `body` map. If the resulting changeset's `valid?` field has value `true`, it returns `{:ok, changeset}`. 

Here's an example function that takes an `appname` string (no, I have no validation for that parameter, at the moment), and a `body` map.

```elixir
  def create_machine(appname, body) do
    IO.inspect(body, label: "body")
    with {:ok, _changeset} <- validate_schema(body, FlyApi.CreateMachineRequest) do
      {:ok, api_response} = FlyMachines.machine_create(appname, body)
      Logger.info("Response status: #{api_response.status}")
      Logger.info("New Machine ID: #{api_response.body["id"]}")
    else
      {:error, errors} -> Logger.info("Invalid CreateMachineRequest. #{inspect errors}")
      _ -> Logger.info("Here's a case that shouldn't happen.")
    end
  end
```

This function uses the aforementioned `validate_schema/2` function to check that `body` has the right stuff in it to make a `
%CreateMachineRequest{}` struct as defined in our schema module . 

### For the Fly Machines API

There are some properties that are required but don't have a `"required"` field or anything to indicate that. So if I want my app to use changesets to check that I haven't forgotten an `"image"` in my Machine `"config"`, I have to go to the `FlyApi.FlyMachineConfig` module and add `|> validate_required([:image])` to the changeset definition.

As of 20 Oct 2024, I've noticed the following required fields inside schemas that I can't easily get programmatically:

* `CreateMachineRequest` and `UpdateMachineRequest` need `config` (which itself has to be a `fly.MachineConfig`)
* `fly.MachineConfig` needs `image`
* `fly.EnvFrom` and `fly.MachineSecret` both need `env_var`, according to their descriptions

The bash script `required_by_description.sh` adds these to the changeset definitions _by editing their module files_. This is brittle and ridiculous but saves me hand-editing all the files every time I regenerate them with the Mix task.


## Cases it tries to handle

The MachinesApiToEcto module looks for

* regular fields and their types
* regular embedded references
* `additionalProperties` and references within
* `allOf` and references within

And it tries, for each component, to
* generate an embedded schema  
* generate `cast/4`, `cast_embed`, and `validate_required` calls as needed in changeset definitions

## What it doesn't do

* Anything at all with the paths; i.e. it doesn't write anything to build requests or check their path parameters.
* Exclude things you'd never want to generate or validate as a consumer of an API, like stuff that'll show up in responses. IDK, maybe you'd want to know what might be in there. But it's a lot of extra files.
* Document anything
* Have tests

If I wanted to validate keyword parameters (like for the other parameters in API calls using functions from https://github.com/ckreiling/fly_machines), I would explore Dashbit's [Nimble Options](https://hexdocs.pm/nimble_options/NimbleOptions.html). I haven't explored deeply enough to know if Nimble Options might be good in place of Ecto embedded schemas for composing request bodies, too.

## Things I was shaky on before starting

* Ecto: background on embedded schemas, changesets, and general critical eye for syntax (fine when you're looking up how to do things, makes for more YOLO-ing copypastas)
* What's in an OpenAPI spec and how references work within them
* The best way to validate a schema like this

## Other things I tried

* the openapi tool for generating a client--I already had a client; I wanted validation more
* generating schemas for Nimble Options, which is for nested keyword lists but might still work for an API like this (I wasn't sure if that would be to the point so switched to Ecto, but I'd like to try it again; I like the documentation possibilities)
* https://github.com/open-api-spex/open_api_spex (didn't descend far enough into the nested references I think.)
