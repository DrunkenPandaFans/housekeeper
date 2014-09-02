CircleServices = angular.module "circleServices", []

CircleServices.factory "Circle", ->
  service =
    query: () -> root.circles,

    get: (id) -> root.circles.find (c) -> c.id == id

    save: (circle) ->
      circle.id = root.circles.length + 1
      root.circles.push(circle)

    update: (circle) ->
      original = @get(circle.id)
      index = root.circles.indexOf(original)
      root.circles[index] = circle

    remove: (id) ->
      root.circles = root.circles.filter (c) -> c.id != id


circles = [{
  id: 1,
  name: "Amazon circle",
  description: "Circle for amazon shopping lists",
  logo: "http://www.turnerduckworth.com/media/filer_public/b4/ac/b4ac5dfe-b335-403c-83b2-ec69e01f94e6/td-amazon-hero.svg",
  shopping_lists: [
    {id: 1, name: "Amazon Xmas shopping", description: "To buy stuff from Amazon right before xmas", deadline: "2014-12-15"},
    {id: 2, name: "Random amazon shopping", description: "Random amazon stuff for greater good", deadline: "2015-01-01"}
  ],
  members: [
    {name: "Jan", email: "jan@email.com", is_moderator: true, image: "http://awesomeurl.com/jan.png"},
    {name: "Sue", email: "sue@email.com", is_moderator: false, image: "http://awesomeurl.com/sue.png"}
  ]
},
{
  id: 2,
  name: "Albert",
  description: "Shopping for generic albert stuff",
  logo: "http://www.albert.cz/-a7643?field=data",
  shopping_lists: [],
  members: [
    {name: "Jan", email: "jan@email.com", is_moderator: false, image: "http://awesomeurl.com/jan.png"},
    {name: "Anka", email: "anka@email.com", is_moderator: true, image: "http://awesomeurl.com/anka.png"}
  ]
},
{
  id: 3,
  name: "My household shopping",
  description: "Shopping for my household.",
  logo: "http://www.fireinspiration.com/wp-content/uploads/logo/logo_40.jpg",
  shopping_list: [
    {id: 1, name: "Shopping list for July 7th", description: "All stuff for house for deadline on July 7th", deadline: "2015-02-01"}
  ],
  members: [
    {name: "Katka", email: "katka@email.com", is_moderator: true, image: "http://awesomeurl.com/katka.png"},
    {name: "Sue", email: "sue@email.com", is_moderator: true, image: "http://awesomeurl.com/sue.png"}
  ]
}]

root = exports ? this

unless root.circles
  root.circles = circles
