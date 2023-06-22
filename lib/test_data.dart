import 'package:admin_app/models/action_model.dart';
import 'package:admin_app/models/genre.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:flutter/material.dart';

final List<ActionModel> userActions = [
  ActionModel(
    icon: Icons.approval,
    name: 'Approve',
  ),
  ActionModel(
    icon: Icons.delete,
    name: 'Delete',
  ),
  ActionModel(
    icon: Icons.visibility,
    name: 'View',
  ),
  // Add additional user actions as needed
];

final List<ActionModel> bookActions = [
  ActionModel(
    icon: Icons.edit,
    name: 'Update',
  ),
  ActionModel(
    icon: Icons.delete,
    name: 'Delete',
  ),
  ActionModel(
    icon: Icons.approval,
    name: 'Approve',
  ),
  ActionModel(
    icon: Icons.visibility,
    name: 'View',
  ),
  // Add additional book actions as needed
];

// Create a list of genres in your app's state
List<Genre> genres = [
  Genre(
    id: "1",
    name: "Science Fiction",
    image_url:
        'https://images.unsplash.com/photo-1579566346927-c68383817a25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  ),
  Genre(
    id: "2",
    name: "Romance",
    image_url:
        'https://images.unsplash.com/photo-1521033719794-41049d18b8d4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Um9tYW5jZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
  ),
  Genre(
    id: "3",
    name: "Mystery",
    image_url:
        'https://images.unsplash.com/photo-1611673982501-93cabee16c77?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fEZpY3Rpb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
  ),
  Genre(
    id: "4",
    name: "Fantasy",
    image_url:
        'https://images.unsplash.com/photo-1560942485-b2a11cc13456?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=436&q=80',
  ),
  Genre(
    id: "5",
    name: "Fiction",
    image_url:
        'https://images.unsplash.com/photo-1624027492684-327af1fb7559?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzR8fEZpY3Rpb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
  ),
  Genre(
    id: "6",
    name: "Horror",
    image_url:
        'https://images.unsplash.com/photo-1601513445506-2ab0d4fb4229?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8SG9ycm9yfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
  ),
  Genre(
    id: "7",
    name: "Biography",
    image_url:
        'https://images.unsplash.com/photo-1601921004897-b7d582836990?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bWFoYXRtYSUyMGdhbmRoaXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
  ),
  Genre(
    id: "8",
    name: "Classic",
    image_url:
        'https://images.unsplash.com/photo-1580974582391-a6649c82a85f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmludGFnZSUyMGRyZXNzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
  ),
];
